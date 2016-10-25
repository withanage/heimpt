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
        self.PROJECT_INPUT_FILE_TYPE_IS_NOT_SPECIFIED   = u'project input file type is not specified'
        self.PROJECT_INPUT_FILE_HAS_MORE_THAN_TWO_DOTS  = u'project input file has more than two dots'
        self.PROJECT_INPUT_FILE_DOES_NOT_EXIST          = u'project input_file does not exist'
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
    
    def reorganize_output(self, ppath, project, typesetter, i, time_now, file_prefix, od_fs, f, uid):
        temp_path = [ppath, uid]
        if typesetter=='metypeset':
            temp_path = temp_path + ['nlm'] 
            print temp_path
        out_type = project['typesetters'][i]['out_type']
        out_file = file_prefix+'.'+out_type
        temp_path.append(out_file)
        temp_path = '/'.join(temp_path)
        if os.path.isfile(temp_path):
            project_path = [ppath, project['name'], time_now,  i+'_'+typesetter,out_type]
            if os.path.isdir(project_path) == False:
                os.makedirs(project_path, '0o777')
            project_path = '/'.join([project_path, out_file])
            print project_path
          #os.rename(temp_path, project_path
        else:
              
          
          
    
        
                   
        
        
        
        
        
