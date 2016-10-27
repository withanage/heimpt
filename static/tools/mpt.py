#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    preProcess.py  <config_file> [options]
Options:
    -d, --debug                                     Enable debug output
"""

__author__ = "Dulip Withnage"

import os
import collections
import json
import sys
import uuid
import datetime
from globals import GV
from debug import Debuggable, Debug
from docopt import docopt
from subprocess import Popen, PIPE
from numpy.ctypeslib import ct
from termcolor import colored


class PreProcess(Debuggable):
    """ converts  source files into xml using the typesetter module"""

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()

    def run(self):
        self.config = self.gv.read_json(self.args['<config_file>'])
        self.typeset_projects()
        return

    @staticmethod
    def read_command_line():
        return docopt(__doc__, version='mpt 0.1')

    def get_module_name(self):
        return 'Pre Processing'

    def typeset_run(self, mt):
        m = ' '.join(mt).strip().split(' ')
        #print 'Final arguments', mt
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        return output, err, exit_code

    def arguments_parse(self, ct):
        mt = []
        if ct.get('executable'):
            mt = [ct.get('executable')]
        else:
            self.debug.print_debug(
                self, self.gv.TYPESETTER_EXECUTABLE_VARIABLE_IS_UNDEFINED)
            sys.exit(1)
        argmts = ct.get("arguments")
        if argmts:
            argmts = collections.OrderedDict(sorted(argmts.items()))
            for a in argmts:
                mt.append(argmts[a])
        else:
            self.debug.print_debug(
                self, self.gv.TYPESETTER_RUNS_WITH_NO_ARGUMENTS)
        return mt

        # print json.dumps(project, indent=4, sort_keys=True)
        # if typestter_id == min (i for i in project['typesetters']):

    def typeset_files(self, project, project_typesetter_name,project_typesetter_out_type,project_typesetter_arguments, project_typesetter_id, time_now):
                return

    def typesets_run(self, project):
        project_typesetters = project.get('typesetters')
        if project_typesetters:
            project_typesetters_ordered = collections.OrderedDict(
                sorted(project_typesetters.items()))
        else:
            self.debug.print_debug(
                self, self.gv.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED)
        time_now = datetime.datetime.now().strftime(
            "%Y_%m_%d-%H-%M-") + str(uuid.uuid4())[:8]
        
        fs = project.get('files')
        all_typesetters = self.config.get('typesetters')
        project_path = project.get('path')
        previous_project_path=''
                                         
        if all_typesetters is None:
            self.debug.print_debug(self, self.gv.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED)
            sys.exit(1)            
                    
        for project_typesetter_id in project_typesetters_ordered:
            if project_typesetters_ordered[project_typesetter_id]:
                project_typesetter_arguments = project_typesetters[project_typesetter_id].get("arguments")
                project_typesetter_name = project_typesetters[project_typesetter_id].get("name")
                project_typesetter_out_type = project_typesetters[project_typesetter_id].get("out_type")
                if project_typesetter_out_type == None:
                    self.debug.print_debug(self, self.gv.TYPESETTER_FILE_OUTPUT_TYPE_IS_UNDEFINED)
                    sys.exit(1)
                if project_typesetter_name:
                    project_files = collections.OrderedDict(sorted(fs.items()))
                    for file_id in project_files:
                        uid = str(uuid.uuid4())[:8]
                        typesetter_properties = all_typesetters.get(project_typesetter_name)
                        if typesetter_properties:
                            mt = self.arguments_parse(typesetter_properties)
                            if self.check_program(typesetter_properties.get('executable')):
                                file_prefix = project_files[file_id].split('.')[0]
                                if project_typesetter_id == min (i for i in project['typesetters']):
                                    file_path = os.path.join(project_path,  project_files[file_id])
                                else:
                                    if project.get("chain") == True:
                                        project_path = previous_project_path
                                    file_path = os.path.join(project_path, file_prefix+'.'+project_typesetter_out_type )
                                  
                                if os.path.isfile(file_path):
                                    mt.append(file_path)
                                    if project_typesetter_arguments:
                                        for arg in project_typesetter_arguments:
                                            if project_typesetter_arguments[arg]== True:
                                                if arg=='out_dir':
                                                    mt.append(os.path.join(project_path, uid))
                                                else:
                                                    mt.append(arg) 
                                    #print mt
                                    print mt
                                    #self.gv.create_dirs_recursive(project_path.split(os.path.sep))
                                    output, err, exit_code = self.typeset_run(mt)
                                    self.debug.print_debug(self,output.decode('utf-8'))
                                    previous_project_path =  self.gv.reorganize_output( project_path, project,project_typesetter_name,project_typesetter_id, time_now, file_prefix,file_id, uid)
                                else:
                                    self.debug.print_debug(
                                        self, self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST + os.path.join(file_path,project_files[file_id].encode('utf-8')))
                            else:
                                self.debug.print_debug(
                                    self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)
                        else:
                            self.debug.print_debug(self, colored(
                                project_typesetter_name, 'red') + " " + self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
   

                else:
                    self.debug.print_debug(
                        self, self.gv.PROJECT_TYPESETTER_NAME_IS_NOT_SPECIFIED)
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTER_IS_NOT_SPECIFIED)

    def tpyeset_project(self, project):
        ''' runs typesetter for  a project '''
        if project.get('active'):
            self.typesets_run(project)
        else:
            self.debug.print_debug(self, self.gv.PROJECT_IS_NOT_ACTIVE)

    def typeset_projects(self):
        projects = self.config.get('projects')
        if projects:
            for p in projects:
                self.tpyeset_project(p)

        else:
            self.debug.print_debug(self, self.gv.PROJECTS_VAR_IS_NOT_SPECIFIED)

    def check_program(self, program):
        def is_exe(fpath):
            return os.path.isfile(fpath) and os.access(fpath, os.X_OK)
        fpath, fname = os.path.split(program)
        if fpath:
            if is_exe(program):
                return program
        else:
            for path in os.environ["PATH"].split(os.pathsep):
                path = path.strip('"')
                exe_file = os.path.join(path, program)
                if is_exe(exe_file):
                    return exe_file

        return None


def main():
    pre_process_instance = PreProcess()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
