metadata.filter('range', function() {
    return function(arr, lower, upper) {
        for (var i = lower; i <= upper; i++){
            arr.push(i);
        }
        return arr;
    };
});

metadata.filter('capitalize', function() {
    return function(input, scope) {
        return input.substring(0,1).toUpperCase()+input.substring(1);
    }
});

metadata.filter('chicagoStyle', ['JsonData', '$filter', function(JsonData, $filter) {
    return function(bib) {
        var settings = JsonData.citation.chicago;
        var citation = '';
        var compiler = '';
        var endsWith = function(str, suffix) {
            return (str)? str.indexOf(suffix, str.length - suffix.length) !== -1 : str;
        };
        var capitalize = function(str){
            return (str)? str.charAt(0).toUpperCase() + str.slice(1) : str;
        };
        var nameOrder = function(obj, order){
            var ret = '';
            if(order === 1){ // last name, -> first name;
                if(obj['surname']){
                    ret += obj['surname'];
                }
                if(obj['given-names']){
                    ret += ', '+obj['given-names'];
                }
            }else if(order === 2){ // first name -> last name
                if(obj['given-names']){
                    ret += obj['given-names']+' ';
                }
                if(obj['surname']){
                    ret += obj['surname'];
                }
            }
            return ret;
        };
        var formatName = function(obj, order){
            var ret = '';
            if(angular.isString(obj)){ // if author name unstructured
                ret += obj;
            }
            if(angular.isObject(obj) && !angular.isArray(obj)){ // if only one author name given
                ret += nameOrder(obj, order);
            }
            if(angular.isArray(obj)){ // if multiple authors given
                if(obj.length <= settings['etal']){
                    angular.forEach(obj, function(author, index){
                        ret += (index === 0)? nameOrder(author, order) : nameOrder(author, 2);
                        if(index + 1 === obj.length - 1){
                            ret += ', '+settings['and']+' '
                        } else if(index + 1 !== obj.length){
                            ret += ', '
                        }
                    });
                } else {
                    ret = obj[0]['surname']+', '+obj[0]['given-names']+' et al'
                }
            }
            return ret;
        };
        if(angular.isObject(bib)){
            if(bib['person-group']){
                if(bib['person-group'].hasOwnProperty('string-name')){ // if only one person group given
                    citation += formatName(bib['person-group']['string-name'], settings['nameOrder']);
                    if(bib['person-group']['@person-group-type'] === 'translator'){
                        citation += ', trans';
                    } else if(bib['person-group']['@person-group-type'] === 'editor'){
                        citation += (angular.isArray(bib['person-group']['string-name']) && bib['person-group']['string-name'].length >= 1)? ', eds' : ', ed';
                    }
                } else if(angular.isArray(bib['person-group'])){
                    angular.forEach(bib['person-group'], function(group, index){
                        switch(group['@person-group-type']){
                            case 'author':
                                citation += formatName(group['string-name'], settings['nameOrder']);
                                break;
                            case 'editor':
                                compiler = (bib['chapter-title'])? 'e': 'E';
                                compiler += 'dited by '+formatName(group['string-name'], 2);
                                compiler += (bib['fpage'])? ', ': '. ';
                                break;
                            case 'translator':
                                compiler = (bib['chapter-title'])? 't': 'T';
                                compiler += 'ranslated by '+formatName(group['string-name'], 2);
                                compiler += (bib['fpage'])? ', ': '. ';
                                break;
                            default:
                                citation += formatName(group['string-name'], settings['nameOrder']);
                                break;
                        }
                    });
                }
                citation += (endsWith(citation, '.'))? ' ' : '. ';
            }
            if(bib['chapter-title']){
                citation += '"'+bib['chapter-title']+'." In ';
            }
            if(bib['article-title']){
                if(angular.isString(bib['article-title'])){
                    citation += '"'+bib['article-title']+'." ';
                }else if(bib['article-title']['related-object']){
                    citation += '"'+bib['article-title']['#text']+'," '+ capitalize(bib['article-title']['related-object']['@content-type'])+' <i>'+bib['article-title']['related-object']['source']+'</i>, by '+formatName(bib['article-title']['related-object']['person-group']['string-name'], 2)+'. ';
                }
            }
            if(bib['source']){
                citation += '<i>'+bib['source']+'</i>';
                citation += (bib['chapter-title'] || bib['volume'] || bib['issue'] || bib['edition'] || bib['fpage'] || compiler || bib['date'])? ', ': '. ';
            }
            if(bib['volume']){
                citation += 'vol. '+bib['volume'];
                citation += (bib['issue'] || bib['edition'] || bib['fpage'] || compiler || bib['date'])? ', ': '. ';
            }
            if(bib['issue']){
                citation += 'no. '+bib['issue'];
                citation += (bib['edition'] || bib['fpage'] || compiler || bib['date'])? ', ': '. ';
            }
            if(bib['edition']){
                citation += bib['edition']+' ed. ';
                citation += (bib['fpage'] || compiler || bib['date'])? ', ': '';
            }
            if(bib['fpage']){
                citation += (bib['lpage'] && bib['fpage'] !== bib['lpage'])? 'pp. ': 'p. ';
                citation += bib['fpage'];
                if(bib['lpage'] && bib['fpage'] !== bib['lpage']){
                    citation += '-'+bib['lpage'];
                }
                citation += (compiler || bib['date'])? ', ': '. ';
            }
            citation += compiler;
            if(bib['publisher-loc']){
                citation += bib['publisher-loc']+': ';
            }
            if(bib['publisher-name']){
                citation += bib['publisher-name']+', ';
            }
            if(bib['conf-name']){
                citation += bib['conf-name']+', ';
            }
            if(bib['conf-loc']){
                citation += bib['conf-loc']+', ';
            }
            if(bib['annotation']){
                citation += bib['annotation']+', ';
            }
            if(bib['institution']){
                citation += bib['institution']+', ';
            }
            if(bib['year']){
                citation += bib['year']+'. ';
            }
            if(bib['date']){
                citation += $filter('date')(new Date(bib['date']), 'MMMM dd, yyyy')+'. ';
            }
            if(bib['date-in-citation']){
                citation += capitalize(bib['date-in-citation']['@content-type'])+' '+$filter('date')(new Date(bib['date-in-citation']['#text']), 'MMMM dd, yyyy')+'. ';
            }
            if(bib['ext-link']){
                citation += bib['ext-link']['#text']+'. ';
            }
            if(bib['isbn']){
                citation += 'ISBN:'+bib['isbn']+'. ';
            }
            if(bib['object-id']){
                citation += bib['object-id']['@content-type'].toUpperCase()+':'+bib['object-id']['#text']+'. ';
            }
            if(endsWith(citation, ' ')){
                citation.slice(0, -1);
            }
        } else {
            citation = bib;
        }
        return citation;
    };
}]);
