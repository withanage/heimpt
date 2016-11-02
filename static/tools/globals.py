# -*- coding: utf-8 -*-

__author__ = "Dulip Withanage"

import json
import os
import sys

from debug import Debuggable, Debug

numeral_map = tuple(zip(
    (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1),
    ('M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I')
))


class GV(object):
    '''
    Global variables
    '''

    def __init__(self):
        # GLOBAL VARIABLES

        # projects
        self.PROJECT_INPUT_FILE_JSON_IS_NOT_VALID = u'project input file json is not valid'
        self.PROJECT_INPUT_FILE_TYPE_IS_NOT_SPECIFIED = u'project input file type is not specified'
        self.PROJECT_INPUT_FILE_HAS_MORE_THAN_TWO_DOTS = u'project input file has more than two dots'
        self.PROJECT_INPUT_FILE_DOES_NOT_EXIST = u'project input_file does not exist'
        self.PROJECT_IS_NOT_ACTIVE = u'project is not active'
        self.PROJECT_OUTPUT_FILE_WAS_NOT_CREATED = u'project output file was not created'
        self.PROJECT_TYPESETTER_IS_NOT_AVAILABLE = u'project typesetter is not available'
        self.PROJECT_TYPESETTER_IS_NOT_SPECIFIED = u'project typesetter is not specified'
        self.PROJECT_TYPESETTER_NAME_IS_NOT_SPECIFIED = u'project typesetter name is not specified'
        self.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED = u'project typesetter varaible is not specified'
        self.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED = u'project typesetters are not specified'
        self.PROJECTS_VAR_IS_NOT_SPECIFIED = u'project variable is not  specified'
        self.PROJECTS_TYPESETTER_RUNS_WITH_NO_ARGUMENTS = u'projects typesetter runs with no arguments'

        # typesetter errors
        self.TYPESETTER_EXECUTABLE_VARIABLE_IS_UNDEFINED = u'typesetter executable variable is undefined'
        self.TYPESETTER_FILE_OUTPUT_TYPE_IS_UNDEFINED = u'typesetter file output type is undefined'
        self.TYPESETTER_METADATA_FILE_WAS_NOT_SPECIFIED = u'Metadata file wasn\'t specified '
        self.TYPESETTER_IS_NOT_SPECIFIED = u'typesetter is not specified '
        self.TYPESETTER_PATH_IS_NOT_SPECIFIED = u'typesetter path is not specified '
        self.TYPESETTER_BINARY_IS_UNAVAILABLE = u'typesetter binary is unavailable '
        self.TYPESETTER_RUNS_WITH_NO_ARGUMENTS = u'typesetter runs with no arguments'

        #xml
        self.XML_FILE_NOT_CREATED=u'xml file not created' 
        self.XML_ELEMENT_NOT_FOUND =u'xml element not found'
        
        self.debug = Debug()
        self.numeral_map = numeral_map
        

    @staticmethod
    def fatal_error(module, message):
        print(u'[FATAL ERROR] [{0}] {1}'.format(
            module.get_module_name(), message))
        sys.exit(1)

    def is_json(self, j):
        try:
            return json.loads(j)
        except ValueError as e:
            return False
        return True

    
    def convert_int_to_roman(self, i):
        result = []
        for integer, numeral in numeral_map:
            count = i // integer
            result.append(numeral * count)
            i -= integer * count
        return ''.join(result)

    def convert_roman_to_int(self, n):
        i = result = 0
        for integer, numeral in numeral_map:
            while n[i:i + len(numeral)] == numeral:
                result += integer
                i += len(numeral)
        return result
    def read_json(self, f):
        if os.path.isfile(f):
            with open(f) as j:
                return json.load(j)
        else:
            self.debug.print_debug(
                self, self.PROJECT_INPUT_FILE_JSON_IS_NOT_VALID)
            sys.exit(1)

   
    def create_xml_file(self, tree, f):
        ''' write element tree to f '''
        try:
            tree.write(
                f,
                pretty_print=True,
                xml_declaration=True,
                encoding='UTF-8')

        except:
            self.debug.print_debug(self, self.XML_FILE_NOT_CREATED)
    