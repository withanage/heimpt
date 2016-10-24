# -*- coding: utf-8 -*-

__author__ = "Dulip Withnage"

import json, os, sys
from debug import Debuggable, Debug

class GV(object):
    '''
    Global variables
    '''
    def __init__(self):
        # GLOBAL VARIABLES
        
        # projects
        self.PROJECT_INPUT_FILE_TYPE_IS_NOT_SPECIFIED   = u'input file type is not specified'
        self.PROJECT_INPUT_FILE_DOES_NOT_EXIST          = u'input_file does not exist'
        self.PROJECT_IS_NOT_ACTIVE                      = u'project is not active'
        self.PROJECT_TYPESETTER_IS_NOT_AVAILABLE        = u'project typesetter is not available'
        self.PROJECT_TYPESETTER_IS_NOT_SPECIFIED        = u'project typesetter is not specified'
        self.PROJECT_TYPESETTER_NAME_IS_NOT_SPECIFIED   = u'project typesetter name is not specified'
        self.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED    = u'project typesetter varaible is not specified'
        self.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED      = u'project typesetters are not :specified'
        self.PROJECTS_VAR_IS_NOT_SPECIFIED              = u'project variable is not  specified'
        self.PROJECTS_TYPESETTER_RUNS_WITH_NO_ARGUMENTS = u'projects typesetter runs with no arguments'
        
        
        # typesetter errors
        self.TYPESETTER_METADATA_FILE_WAS_NOT_SPECIFIED = u'Metadata file wasn\'t specified '
        self.TYPESETTER_IS_NOT_SPECIFIED                = u'typesetter is not specified '
        self.TYPESETTER_PATH_IS_NOT_SPECIFIED           = u'typesetter path is not specified '
        self.TYPESETTER_BINARY_IS_UNAVAILABLE           = u'typesetter binary is unavailable '
        self.TYPESETTER_RUNS_WITH_NO_ARGUMENTS          = u'typesetter runs with no arguments'
        
    # xml process
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

    def read_json(self, f):
        if os.path.isfile(f):
            with open(f) as j:
                return json.load(j)
        else:
            self.debug.print_debug(self,)
            sys.exit(1)
    
    
        
        
        
        
        
