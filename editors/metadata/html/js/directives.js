

/* metadataFields directive */
metadata.directive('metadataFields', function(){
    return {
        restrict: "E",
        templateUrl: './tpls/metadataFields.html'
    };
});

/* bookMeta directive */
metadata.directive('bookMeta', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/bookMeta.html'
    };
});

/* bookChapter directive*/
metadata.directive('bookChapter', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/bookChapter.html'
    };
});

/* bookPart directive */
metadata.directive('bookPart', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/bookPart.html'
    };
});

/* bookBackMatter directive */
metadata.directive('bookBack', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/bookBackMatter.html'
    };
});

/* chapterBackMatter directive */
metadata.directive('chapterBack', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/chapterBackMatter.html'
    };
});

/* glossary directive */
metadata.directive('glossary', function(){
    return{
        restrict: "E",
        scope: {
            content: '=defList'
        },
        templateUrl: './tpls/glossary.html',
        controller : ['$scope', function($scope) {
            $scope.triggerClick = $scope.$parent.triggerClick;
            $scope.typeOf = $scope.$parent.typeOf;
            $scope.omit = $scope.$parent.omit;
        }]
    };
});

/* bibliography directive */
metadata.directive('bibliography', function(){
    return{
        restrict: "E",
        scope: {
            content: '=refList'
        },
        templateUrl: './tpls/bibliography.html',
        controller : ['$scope','JsonData', function($scope, JsonData) {
            $scope.bibType = JsonData.bibType;
            $scope.triggerClick = $scope.$parent.triggerClick;
            $scope.typeOf = $scope.$parent.typeOf;
            $scope.omit = $scope.$parent.omit;
        }]
    };
});

/* footnotes directive */
metadata.directive('footnotes', function(){
    return{
        restrict: "E",
        scope: {
            content: '=fnGroup'
        },
        templateUrl: './tpls/footnotes.html',
        controller : ['$scope', function($scope) {
            $scope.triggerClick = $scope.$parent.triggerClick;
            $scope.typeOf = $scope.$parent.typeOf;
            $scope.omit = $scope.$parent.omit;
        }]
    };
});

/* appendix directive */
metadata.directive('appendix', function(){
    return{
        restrict: "E",
        scope: {
            content: '=app'
        },
        templateUrl: './tpls/appendix.html',
        controller : ['$scope', function($scope) {
            $scope.triggerClick = $scope.$parent.triggerClick;
            $scope.typeOf = $scope.$parent.typeOf;
        }]
    };
});

/* headings directive */
metadata.directive('headings', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/headings.html'
    };
});

metadata.directive('header', function(){
    return {
        restrict: "E",
        scope: {
            step: '='
        },
        templateUrl: './tpls/header.html'
    };
});

metadata.directive('navBar', function(){
    return {
        restrict: "E",
        scope: {
            step: '=stepNumber'
        },
        controller: ['$scope', function($scope){
            $scope.st = $scope.$parent.stepNumber;
            $scope.update = function(n){
                $scope.st = n;
                $scope.$parent.stepNumber = n;
                $scope.$parent.gotoAnchor(n);
            }
        }],
        templateUrl: './tpls/navBar.html'
    };
});

metadata.directive('footer', function(){
    return {
        restrict: "E",
        templateUrl: './tpls/footer.html',
        controller : ['$scope','JsonData', function($scope, JsonData) {
            $scope.contents = JsonData.tree;
        }]
    };
});

/* step2 directive */
metadata.directive('step2', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/step2.html'
    };
});

/* headings directive */
metadata.directive('step3', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/step3.html'
    };
});

/* headings directive */
metadata.directive('step4', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/step4.html'
    };
});

/* headings directive */
metadata.directive('step5', function(){
    return{
        restrict: "E",
        templateUrl: './tpls/step5.html'
    };
});

