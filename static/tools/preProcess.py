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
from globals import GV
from debug import Debuggable, Debug
from docopt import docopt
from subprocess import Popen, PIPE
from numpy.ctypeslib import ct


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
        print ' '.join(mt)
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        if exit_code != 0:
            print output
        return output, err, exit_code

    def typeset_file(self, project, mt, od_fs, f):
        if project.get('path'):
            self.typeset_run(mt)
        else:
            self.debug.print_debug(self, self.gv.TYPESETTER_METADATA_FILE_WAS_NOT_SPECIFIED)


    def arguments_parse(self, ct):
        mt = []
        if ct.get('executable'):
            mt = [ct.get('executable')]
        else:
            self.debug.print_debug(self, self.gv.TYPESETTER_IS_NOT_SPECIFIED)
            sys.exit(1)
        argmts = ct.get("arguments")
        if argmts:
            argmts = collections.OrderedDict(sorted(argmts.items()))
            for a in argmts:
                mt.append(argmts[a])
        else:
            self.debug.print_debug(self, self.gv.TYPESETTER_RUNS_WITH_NO_ARGUMENTS)
        return mt

    def typeset_files(self, project, ct):
        fs = project.get('files')
        od_fs = collections.OrderedDict(sorted(fs.items()))
        
        for f in od_fs:
            mt = self.arguments_parse(ct)
            if self.check_program(ct.get('executable')):
                ppath = project.get('path')
                fl = os.path.join(ppath, od_fs[f])
                if os.path.isfile(fl):
                    mt.append(fl)
                    mt.append(os.path.join(ppath, str(uuid.uuid4())))
                    self.typeset_file(project, mt, od_fs, f)
                else:
                    self.debug.print_debug(self, self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST + od_fs[f].encode('utf-8'))
            else:
                self.debug.print_debug(
                    self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)

   
    def typesets_run(self, project, pts):
        print pts
        for i in pts:
            if pts[i]:
                if pts[i].get("name"):
                    typesetter = pts[i].get("name")
                    tss = self.config.get('typesetters')
                    if tss:
                        ct = tss.get(typesetter)
                        if ct:
                            self.typeset_files(project, ct)
                        else:
                            self.debug.print_debug(self, self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
                    else:
                        self.debug.print_debug(self, self.gv.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED)
                else:
                    self.debug.print_debug(self, self.gv.PROJECT_TYPESETTER_NAME_IS_NOT_SPECIFIED)
            else:
                self.debug.print_debug(self, self.gv.PROJECT_TYPESETTER_IS_NOT_SPECIFIED)

    def tpyeset_project(self, project):
        ''' runs typesetter for  a project '''
        if project.get('active'):
            pts = project.get('typesetters')
            if pts:
                pts = collections.OrderedDict(sorted(pts.items()))
                self.typesets_run(project, pts)
            else:
                self.debug.print_debug(self, self.gv.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED)
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
