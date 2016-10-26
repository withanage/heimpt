# -*- coding: utf-8 -*-

__author__ = "Dulip Withanage"

import json
import os
import sys
import shutil
from debug import Debuggable, Debug


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
        self.PROJECT_OUTPUT_FILE_WAS_NOT_CREATED = u'sproject output file was not created'
        self.PROJECT_TYPESETTER_IS_NOT_AVAILABLE = u'project typesetter is not available'
        self.PROJECT_TYPESETTER_IS_NOT_SPECIFIED = u'project typesetter is not specified'
        self.PROJECT_TYPESETTER_NAME_IS_NOT_SPECIFIED = u'project typesetter name is not specified'
        self.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED = u'project typesetter varaible is not specified'
        self.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED = u'project typesetters are not :specified'
        self.PROJECTS_VAR_IS_NOT_SPECIFIED = u'project variable is not  specified'
        self.PROJECTS_TYPESETTER_RUNS_WITH_NO_ARGUMENTS = u'projects typesetter runs with no arguments'

        # typesetter errors
        self.TYPESETTER_METADATA_FILE_WAS_NOT_SPECIFIED = u'Metadata file wasn\'t specified '
        self.TYPESETTER_IS_NOT_SPECIFIED = u'typesetter is not specified '
        self.TYPESETTER_PATH_IS_NOT_SPECIFIED = u'typesetter path is not specified '
        self.TYPESETTER_BINARY_IS_UNAVAILABLE = u'typesetter binary is unavailable '
        self.TYPESETTER_RUNS_WITH_NO_ARGUMENTS = u'typesetter runs with no arguments'

        #
        self.debug = Debug()

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
            self.debug.print_debug(
                self, self.PROJECT_INPUT_FILE_JSON_IS_NOT_VALID)
            sys.exit(1)

    def create_dirs_recursive(self, project_path):
        p = ''
        for path in project_path:
            p = p + os.path.sep + path.strip('/').strip('/')
            if not os.path.exists(p):
                os.makedirs(p)
        return p

    def reorganize_output(self, ppath, project, typesetter, i, time_now, file_prefix, f, uid):
        temp_path = [ppath, uid]
        
        if typesetter == 'metypeset':
            temp_path = temp_path + ['nlm']
        out_type = project['typesetters'][i]['out_type']
        temp_path.append(file_prefix + '.' + out_type)
        temp_file = os.path.sep.join(temp_path)
        if os.path.isfile(temp_file):
            project_path = [ppath, project['name'],time_now,  i + '_' + typesetter, out_type]
            p = self.create_dirs_recursive(project_path)
            file_path = p + os.path.sep + file_prefix + '.' + out_type
            os.rename(temp_file, file_path)
            shutil.rmtree(os.path.join(ppath, uid))
        else:
            self.debug.print_debug(
                self, self.PROJECT_OUTPUT_FILE_WAS_NOT_CREATED)
            
