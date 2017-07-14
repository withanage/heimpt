'use strict';

var components = ['textAngular',
'jsTree.directive', 'xeditable', 'ui.bootstrap', 'underscore',
'ui.sortable', 'ui.tree', 'ui.tinymce'];
var metadata = angular.module('metadata', components);

metadata.config(function($locationProvider) {
    $locationProvider.html5Mode(true);
});

// xeditable config
metadata.run(function(editableOptions, editableThemes) {
    // set theme bootstrap3
    editableOptions.theme = 'bs3';

    // overwrite button templates
    editableThemes['bs3'].submitTpl = '<button type="submit" class="btn btn-primary">save</button>';
    editableThemes['bs3'].cancelTpl = '<button type="button" class="btn btn-default" ng-click="$form.$cancel()">cancel</button>';
});


//TODO add this
metadata.run(['$anchorScroll', function($anchorScroll) {
    $anchorScroll.yOffset = 150;   // always scroll by 50 extra pixels
}])


metadata.factory('JsonData', ['$http', '$rootScope', function($http, $rootScope){
    return {
        getData: function (filename, id) {
            return $http.get("../cgi/"+filename).success(function(data) {
                $rootScope.$broadcast('broadcast:'+id, data);
                return data;
            });
        },
        tree: null,
        pubType : ['pdf', 'epub', 'html'],
        dateType : ['created', 'reviewed', 'updated'],
        idType : [
            { name: 'archive', info: 'Identifier assigned by an archive or other repository for articles' },
            { name: 'aggregator', info: 'Identifier assigned by a data aggregator' },
            { name: 'doaj', info: 'Directory of Open Access Journals'},
            { name: 'doi', info: 'Digital Object Identifier for the entire journal, not just for the article (rare)' },
            { name: 'index', info: 'Identifier assigned by an abstracting or indexing service' },
            { name: 'publisher-id', info: 'Identifier assigned by the content publisher, for example, "University Press"'},
            { name: 'other', info: ''}
        ],
        contribType : ['author', 'editor', 'translator', 'designer'],
        degreeType : ['BA', 'MA', 'PhD'],
        copyrightYear : ['2013', '2014', '2015'],
        licenseType : [
            {name: 'public-domain', info: 'public domain'},
            {name: 'open-access', info: 'open access'},
            {name: 'CC BY', info: 'Creative Commons Attribution License'},
            {name: 'CC BY-ND', info: 'Creative Commons Attribution-NoDerivatives License'},
            {name: 'CC BY-SA', info: 'Creative Commons Attribution-ShareAlike License'},
            {name: 'CC BY-NC', info: 'Creative Commons Attribution-NonCommercial License'},
            {name: 'CC BY-NC-ND', info: 'Creative Commons Attribution-NonCommercial-NoDerivatives License'},
            {name: 'CC BY-NC-SA', info: 'Creative Commons Attribution-NonCommercial-ShareAlike License'}
        ],
        languages : {'en':'English', 'de':'German', 'fr':'French', 'es': 'Spanish', 'zh':'Chinese', 'ja':'Japanese'},
        bibType : ['book', 'book chapter', 'book review', 'conference proceeding', 'journal article', 'newspaper/magazine article', 'thesis', 'website', 'other'],
        citation : {
            chicago: {etal: 4, nameOrder: 1, and: 'and', abbrev: {}}
        },
        stepTitle : [
            'Drag & Drop Your Files', // step 1
            'Add Metadata',// step 2
            'Confirm Back Matter',// step 3
            'Confirm Heading Structure',// step 4
            'Confirm parenthetical reference list', // step 5
            'Media insertion', // step 6
            'Table captions', // step 7
            'Freeform editing', // step 8
        ]
    };
}]);

metadata.controller('textCtrl',
    ['$scope', '$http', '$filter', '$modal', '$timeout', '$location', '$anchorScroll', '_', 'JsonData', function($scope, $http, $filter, $modal, $timeout, $location, $anchorScroll, _, JsonData){
        // json data
        /*
        $http.get("../cgi/bookJson.py").success(function(data){
            $scope.tree = data;
            $scope.origTree = data; // Do not edit this tree!! (read-only)
            JsonData.tree = data;
        });
        */
        JsonData.getData('../../../../../heidieditor/editor/call/json/bookJson', 'bookJson').then(function(res){
            $scope.tree = res.data;
            $scope.origTree = res.data; // Do not edit this tree!! (read-only)
            JsonData.tree = res.data;
        });

        // initial values
        $scope.pubType = JsonData.pubType;
        $scope.dateType = JsonData.dateType;
        $scope.today = $filter('date')(new Date(),'yyyy-MM-dd');
        $scope.idType = JsonData.idType;
        $scope.contribType = JsonData.contribType;
        $scope.copyrightYear = JsonData.copyrightYear;
        $scope.backMatter = {'fn-group': 'Endnotes', 'glossary': 'Glossary', 'ref-list': 'Bibliography', 'app-group': 'Appendix'};
        $scope.stepNumber = 5;
        $scope.getStepTitle = function(n){
            return JsonData.stepTitle[n-1];
        };

        // formatting
        $scope.makeDate = function(str){
            return new Date(str);
        };

        // operations
        $scope.deepCopy = function(obj){
            return angular.copy(obj);
        };
        $scope.isEqual = function(obj1, obj2){
            return _.isEqual($scope.deepCopy(obj1), $scope.deepCopy(obj2));
        };
        $scope.copyMetadata = function($event, chapter){
            if($event){
                $timeout(function() {
                    angular.forEach(angular.element('input:not(:checked).copy.'+chapter), function(value, key){
                        angular.element(value).triggerHandler('click');
                    });
                }, 0);
            }
        };
        $scope.triggerClick = function(selector){
            $timeout(function() {
                angular.element(selector).trigger('click');
            }, 0);
        };
        $scope.omit = function(obj, key){
            console.log('omit', _.omit(obj, key));
            return _.omit(obj, key);
        };
        $scope.jumpTo = function (id) {
            console.log(id);
            $location.hash(id);
            $anchorScroll();
        };
        $scope.typeOf = function(obj){
            return Object.prototype.toString.call(obj).slice(8, -1);
        };
        $scope.gotoAnchor = function(x) {
            $scope.stepNumber = x;
            var newHash = 'step' + x;
            if ($location.hash() !== newHash) {
                // set the $location.hash to `newHash` and
                // $anchorScroll will automatically scroll to it
                $location.hash('step' + x);
            } else {
                // call $anchorScroll() explicitly,
                // since $location.hash hasn't changed
                $anchorScroll();
            }
        };

        // validation
        $scope.isEmpty = function(data){
          if(!data){
              return "required!"
          }
        };

        // modal windows
        $scope.openContrib = function(_contrib) {
            $modal.open({
                templateUrl: 'tpls/contributors.html',
                controller: 'contribInstanceCtrl',
                size: 'lg',
                resolve: {contrib: function(){
                    return _contrib;
                }}
            });
        };
        $scope.openAff = function(_aff) {
            $modal.open({
                templateUrl: 'tpls/affiliations.html',
                controller: 'affInstanceCtrl',
                size: 'lg',
                resolve: {aff: function(){
                    return _aff;
                }}
            });
        };
        $scope.openTitle = function(_title) {
            $modal.open({
                templateUrl: 'tpls/titles.html',
                controller: 'titleInstanceCtrl',
                size: 'lg',
                resolve: {title: function(){
                    return _title;
                }}
            });
        };
        $scope.openPermissions = function(_permissions) {
            $modal.open({
                templateUrl: 'tpls/permission.html',
                controller: 'permissionsInstanceCtrl',
                size: 'lg',
                resolve: {permissions: function(){
                    return _permissions;
                }}
            });
        };


        // jstree selection
        $scope.booktree = {selected : ''};
        /*
        $scope.$watch('tree', function(newVal, oldVal) {
            console.log('watch!', newVal);
            $scope.$broadcast('rootScope:bookJson', newVal);
        },true);
        */

        // ui-sortable config
        $scope.sortableOptions = {
            /*handle: '> .handle',
            helper: "clone",
            start: function(event, ui){
                //console.log(ui);
                //ui.item.css('border', '1px solid red');
            }
            update: function(event, ui){
                //
            },
            stop: function(event, ui){
                console.log("New position: " + ui.item.index());
            }*/
        };





        // ui-tree
        $scope.uiTreeRemove = function(scope) {
            scope.remove();
        };

        $scope.uiTreeToggle = function(scope) {
            scope.toggle();
        };

        $scope.uiTreeNewSubItem = function(scope) {
            var nodeData = scope.$modelValue;
            nodeData.items.push({
                id: nodeData.id * 10 + nodeData.items.length,
                title: nodeData.title + '.' + (nodeData.items.length + 1),
                items: []
            });
        };

        // tinymce
        $scope.tinymceOptions = {
            plugins: "table",
            tools: "inserttable"
        }
    }]
);

/* jstree controller */
metadata.controller('jstreeCtrl',
    ['$scope','$timeout', 'JsonData', function($scope, $timeout, JsonData) {
        $scope.$on('broadcast:step', function(e, data) {
            $
        });

        // initialize
        $scope.$on('broadcast:bookJson', function(e, data) {
            console.log('broadcast!', data);
            function assignNode(current, parent){
                var tmp = {};
                tmp['text'] = current['@id'];
                tmp['id'] = current['@id'];
                tmp['state'] = {'opened': true, 'selected': false};
                tmp['type'] = current['@book-part-type'];
                tmp['parent'] = parent;
                $scope.navmenu.push(tmp);
            };
            $scope.navmenu = [{
                'text': data['book']['book-meta']['book-id']['#text'],
                'id': data['book']['book-meta']['book-id']['#text'],
                'state': {
                    'opened': true,
                    'selected': true
                },
                'type': 'book',
                'parent': '#'
            }];
            if (angular.isArray(data['book']['body']['book-part'])) {
                angular.forEach(data['book']['body']['book-part'], function (i) {
                    assignNode(i, data['book']['book-meta']['book-id']['#text']);
                    if (angular.isArray(i['body']['book-part'])) {
                        angular.forEach(i['body']['book-part'], function (j) {
                            assignNode(j, i['@id']);
                        });
                    } else {
                        assignNode(i['body']['book-part'], data['book']['body']['book-part']['@id']);
                    }
                });
            } else {
                assignNode(data['book']['body']['book-part'], data['book']['book-meta']['book-id']['#text']);
                if (angular.isArray(data['book']['body']['book-part']['body']['book-part'])) {
                    angular.forEach(data['book']['body']['book-part']['body']['book-part'], function (j) {
                        assignNode(j, data['book']['body']['book-part']['@id']);
                    });
                } else {
                    assignNode(data['book']['body']['book-part']['body']['book-part'], data['book']['body']['book-part']['@id']);
                }
            }
        },true);

        // jsTree config
        $scope.typesConfig = {
            "book": {
                "icon": "glyphicon glyphicon-folder-open"
            },
            "part": {
                "icon": "glyphicon glyphicon-folder-open"
            },
            "chapter": {
                "icon": "glyphicon glyphicon-file"
            }
        };
        $scope.changedCB = function(e, data){
            $scope.booktree.selected = data.selected[0];
            $timeout(function() { //dummy function!
            }, 0);
        };


    }]
);

/* navmenu controller */
metadata.controller('navmenuCtrl',
    ['$scope','$timeout', 'JsonData', function($scJsonData) {
        // jsTree config
        $scope.typesConfig = {
            "book": {
                "icon": "glyphicon glyphicon-folder-open"
            },
            "part": {
                "icon": "glyphicon glyphicon-folder-open"
            },
            "chapter": {
                "icon": "glyphicon glyphicon-file"
            }
        };
        $scope.changedCB = function(e, data){
            $scope.booktree.selected = data.selected[0];
            $timeout(function() { //dummy function!
            }, 0);
        };


    }]
);

/* modal instance controller for contributor */
metadata.controller('contribInstanceCtrl',
    ['$scope', '$modalInstance', '$timeout', 'contrib', 'JsonData', function($scope, $modalInstance, $timeout, contrib, JsonData) {
        $scope.contrib = contrib;
        $scope.contribType = JsonData.contribType;
        $scope.degreeType = JsonData.degreeType;
        $scope.aff = JsonData.tree['book']['book-meta']['aff'];
        $scope.triggerClick = function(selector){
            $timeout(function() {
                angular.element(selector).trigger('click');
            }, 0);
        };
        $scope.cancel = function(){
            $modalInstance.dismiss(false);
        };
    }]
);

/* modal instance controller for affiliation */
metadata.controller('affInstanceCtrl',
    ['$scope', '$modalInstance', '$timeout', 'aff', function($scope, $modalInstance, $timeout, aff) {
        $scope.aff = aff;
        $scope.triggerClick = function(selector){
            $timeout(function() {
                angular.element(selector).trigger('click');
            }, 0);
        };
        $scope.cancel = function(){
            $modalInstance.dismiss(false);
        };
    }]
);

/* modal instance controller for title */
metadata.controller('titleInstanceCtrl',
    ['$scope', '$modalInstance', '$timeout', 'title', 'JsonData', function($scope, $modalInstance, $timeout, title, JsonData) {
        $scope.title = title;
        $scope.languages = JsonData.languages;
        $scope.triggerClick = function(selector){
            $timeout(function() {
                angular.element(selector).trigger('click');
            }, 0);
        };
        $scope.cancel = function(){
            $modalInstance.dismiss(false);
        };
    }]
);

/* modal instance controller for permissions */
metadata.controller('permissionsInstanceCtrl',
    ['$scope', '$modalInstance', '$timeout', 'permissions', 'JsonData', function($scope, $modalInstance, $timeout, permissions, JsonData) {
        $scope.permissions = permissions;
        $scope.licenseType = JsonData.licenseType;
        $scope.triggerClick = function(selector){
            $timeout(function() {
                angular.element(selector).trigger('click');
            }, 0);
        };
        $scope.cancel = function(){
            $modalInstance.dismiss(false);
        };
    }]
);


metadata.controller('modalCtrl',
    ['$scope', '$modal', function($scope, $modal) {
        $scope.open = function () {
            $modal.open({
                templateUrl: 'checkSource.html',
                windowTemplateUrl: 'aside.template.html',
                controller: 'asideCtrl'
            });
        }
    }]
);

metadata.controller('asideCtrl',
    ['$scope', '$modalInstance', 'JsonData', function($scope, $modalInstance, JsonData) {
        $scope.contents = JsonData.tree;

        $scope.close = function(){
            JsonData.tree = $scope.contents;
            $modalInstance.close();
        };
        $scope.cancel = function(){
            $modalInstance.dismiss('cancel');
        };
    }]
);

