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
        print 'Final path', ' '.join(mt)
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        if exit_code != 0:
            print output
        return output, err, exit_code


    def arguments_parse(self, ct):
        mt = []
        if ct.get('executable'):
            mt = [ct.get('executable')]
        else:
            self.debug.print_debug(self, self.gv.TYPESETTER_EXECUTABLE_VARIABLE_IS_UNDEFINED)
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


        #print json.dumps(project, indent=4, sort_keys=True)
        #if typestter_id == min (i for i in project['typesetters']): 
   
    def typeset_files(self, project, typesetter, typesetter_id, time_now):
        print typesetter
                    
        uid = str(uuid.uuid4())[:8]
        file_prefix = ''
        tss = self.config.get('typesetters')
        if tss is None:
            self.debug.print_debug(self, self.gv.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED)
            sys.exit(1)
        fs = project.get('files')
        project_files = collections.OrderedDict(sorted(fs.items()))
        for file_id in project_files:
            ct = tss.get(typesetter)
            if ct:
                mt = self.arguments_parse(ct)
                if self.check_program(ct.get('executable')):
                    print typesetter, 3
                    project_path = project.get('path')
                    file_path = os.path.join(project_path, project_files[file_id])
                    if os.path.isfile(file_path):
                        print typesetter, 4
                        mt.append(file_path)
                        file_name = project_files[file_id].split('.')
                        file_prefix = file_name[0]
                        mt.append(os.path.join(project_path, uid))
                        self.typeset_run(mt)
                        print 100*'-'
                        '''
                        print project_path
                        print json.dumps(project, indent=4, sort_keys=True)
                        print 'typesetter', typesetter
                        print time_now
                        print file_prefix
                        print 'file_id=file_id',file_id
                        print uid
                        '''
                        self.gv.reorganize_output(project_path, project, typesetter, typesetter_id, time_now, file_prefix,  file_id, uid)
                    else:
                        self.debug.print_debug(
                            self, self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST + project_files[file_id].encode('utf-8'))
                else:
                    self.debug.print_debug(
                        self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)
            else:
                self.debug.print_debug(self, colored(
                    typesetter, 'red') + " " + self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
        return

    def typesets_run(self, project):
        project_typesetters = project.get('typesetters')
        if project_typesetters:
                project_typesetters_ordered = collections.OrderedDict(sorted(project_typesetters.items()))
        else:
            self.debug.print_debug( self, self.gv.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED)    
        time_now = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-")+str(uuid.uuid4())[:8]
        for i in project_typesetters_ordered:
            
            if project_typesetters_ordered[i]:
                if project_typesetters[i].get("name"):
                    typesetter = project_typesetters[i].get("name")
                    self.typeset_files(project, typesetter, i, time_now)
                    
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
