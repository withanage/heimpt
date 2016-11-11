#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    preProcess.py  <config_file> [options]
Options:
    -d, --debug                                     Enable debug output
"""

__author__ = "Dulip Withanage"

import os
import collections
import json
import sys
import shutil
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
        self.time_now = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-") + str(uuid.uuid4())[:8]

    def run(self):
        self.config = self.gv.read_json(self.args['<config_file>'])
        self.typeset_all_projects()
        return

    @staticmethod
    def read_command_line():
        return docopt(__doc__, version='mpt 0.1')

    def get_module_name(self):
        return 'Monograph Publishing Tool'

    def call_typesetter(self, mt):
        m = ' '.join(mt).strip().split(' ')
        self.debug.print_debug(self,  ' '.join(m))
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
        arguments = ct.get("arguments")
        if arguments:
            arguments = collections.OrderedDict(sorted(arguments.items()))
            for a in arguments:
                mt.append(arguments[a])
        return mt

    def parse_project_typestter_arguments(
            self,
            project_typesetter_arguments,
            project_typesetter_out_type,
            project_typesetter_out_path,
            mt,
            file_prefix):
        for i in project_typesetter_arguments:
            arg = project_typesetter_arguments[i]
            if arg == 'fn:append_out_dir':
                mt.append(project_typesetter_out_path)
            elif arg == 'fn:create_out_file':
                if not os.path.exists(project_typesetter_out_path):
                    os.makedirs(project_typesetter_out_path)
                mt.append(
                    os.path.join(
                        project_typesetter_out_path,
                        file_prefix +
                        '.' +
                        project_typesetter_out_type))
            else:
                mt.append(arg)

    def run_typesetter(
            self,
            project,
            project_path,
            previous_project_path,
            previous_project_typesetter_out_type,
            project_typesetter_id,
            project_typesetter_arguments,
            project_typesetter_name,
            project_typesetter_out_type,
            uid,
            project_typesetter_out_path,
            project_files,
            file_id,
            mt):
        previous_project_path_temp = ''
        temp = ''
        file_prefix = project_files[file_id].split('.')[0]
        if project_typesetter_id == min(i for i in project['typesetters']):
            file_path = os.path.join(project_path, project_files[file_id])
        elif project.get("chain") == True:
            file_path = os.path.join(
                previous_project_path,
                file_prefix +
                '.' +
                previous_project_typesetter_out_type)
        if os.path.isfile(file_path):
            mt.append(file_path)
            if project_typesetter_arguments:
                self.parse_project_typestter_arguments(
                    project_typesetter_arguments,
                    project_typesetter_out_type,
                    project_typesetter_out_path,
                    mt,
                    file_prefix)
            output, err, exit_code = self.call_typesetter(mt)
            previous_project_path_temp = self.reorganize_output(
                project_path,
                project,
                project_typesetter_name,
                project_typesetter_id,
                file_prefix,
                project_files,
                file_id,
                uid)

            temp = project_typesetter_out_type
        else:
            self.debug.print_debug(
                self,
                self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST +
                os.path.join(file_path))
        return previous_project_path_temp, temp

    def typeset_file(
            self,
            project,
            all_typesetters,
            project_path,
            previous_project_path,
            previous_project_typesetter_out_type,
            project_typesetter_id,
            project_typesetter_arguments,
            project_typesetter_name,
            project_typesetter_out_type,
            uid,
            project_typesetter_out_path,
            project_files,
            file_id):
        typesetter_properties = all_typesetters.get(project_typesetter_name)
        previous_project_path_temp, previous_project_typesetter_out_type_temp= '',''
        if typesetter_properties:
            mt = self.arguments_parse(typesetter_properties)
            if self.check_program(typesetter_properties.get('executable')):
                previous_project_path_temp, previous_project_typesetter_out_type_temp = self.run_typesetter(
                    project,
                    project_path,
                    previous_project_path,
                    previous_project_typesetter_out_type,
                    project_typesetter_id,
                    project_typesetter_arguments,
                    project_typesetter_name,
                    project_typesetter_out_type,
                    uid,
                    project_typesetter_out_path,
                    project_files,
                    file_id,
                    mt)
            else:
                self.debug.print_debug(
                    self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)
        else:
            self.debug.print_debug(
                self,
                colored(
                    project_typesetter_name,
                    'red') +
                " " +
                self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
        return previous_project_path_temp, previous_project_typesetter_out_type_temp

    def run_typestter_for_all_files_in_project(
            self,
            project,
            project_typesetters,
            fs,
            all_typesetters,
            project_path,
            previous_project_path,
            previous_project_typesetter_out_type,
            project_typesetter_id):
        previous_project_path_temp, previous_project_typesetter_out_type_temp='',''
        project_typesetter_arguments = collections.OrderedDict(
            sorted(project_typesetters[project_typesetter_id].get("arguments").items()))
        project_typesetter_name = project_typesetters[
            project_typesetter_id].get("name")
        project_typesetter_out_type = project_typesetters[
            project_typesetter_id].get("out_type")
        uid = str(uuid.uuid4())[:8]
        project_typesetter_out_path = os.path.join(project_path, uid)
        if project_typesetter_out_type is None:
            self.debug.print_debug(
                self, self.gv.TYPESETTER_FILE_OUTPUT_TYPE_IS_UNDEFINED)
            sys.exit(1)
        if project_typesetter_name:
            project_files = collections.OrderedDict(sorted(fs.items()))

            for file_id in project_files:
                previous_project_path_temp, previous_project_typesetter_out_type_temp = self.typeset_file(
                    project,
                    all_typesetters,
                    project_path,
                    previous_project_path,
                    previous_project_typesetter_out_type,
                    project_typesetter_id,
                    project_typesetter_arguments,
                    project_typesetter_name,
                    project_typesetter_out_type,
                    uid,
                    project_typesetter_out_path,
                    project_files,
                    file_id
                )

        else:
            self.debug.print_debug(
                self, self.gv.PROJECT_TYPESETTER_NAME_IS_NOT_SPECIFIED)
        return previous_project_path_temp, previous_project_typesetter_out_type_temp

    def run_all_typesetters_for_project(self, project):
        project_typesetters_ordered, pp_path_temp,pp_typesetter_out_type_temp='','',''
        if project.get('active'):
            project_typesetters = project.get('typesetters')
            if project_typesetters:
                project_typesetters_ordered = collections.OrderedDict(
                    sorted(project_typesetters.items()))
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED)

            fs = project.get('files')
            all_typesetters = self.config.get('typesetters')
            project_path = project.get('path')
            previous_project_path = ''
            previous_project_typesetter_out_type = ''

            if all_typesetters is None:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED)
                sys.exit(1)

            for project_typesetter_id in project_typesetters_ordered:
                if project_typesetters_ordered[project_typesetter_id]:
                    pp_path_temp, pp_typesetter_out_type_temp = self.run_typestter_for_all_files_in_project(
                        project,
                        project_typesetters,
                        fs,
                        all_typesetters,
                        project_path,
                        previous_project_path,
                        previous_project_typesetter_out_type,
                        project_typesetter_id
                    )
                else:
                    self.debug.print_debug(
                        self, self.gv.PROJECT_TYPESETTER_IS_NOT_SPECIFIED)
                previous_project_path = pp_path_temp
                previous_project_typesetter_out_type = pp_typesetter_out_type_temp
        else:
            self.debug.print_debug(self, self.gv.PROJECT_IS_NOT_ACTIVE)

    def typeset_all_projects(self):
        projects = self.config.get('projects')
        if projects:
            for p in projects:
                self.run_all_typesetters_for_project(p)

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

    def reorganize_output(
            self,
            ppath,
            project,
            typesetter,
            i,
            file_prefix,
            project_files,
            file_id,
            uid):

        temp_path = [ppath, uid]
        project_path,p = '',''
        if typesetter == 'metypeset':
            temp_path = temp_path + ['nlm']
        out_type = project['typesetters'][i]['out_type']
        project_path = [
            ppath,
            project['name'],
            self.time_now,
            i + '_' + typesetter,
            out_type]
        if project['typesetters'][i].get('merge'):
            ff = project['typesetters'][i].get('arguments')["3"]
            temp_path.append(ff)
            temp_file = os.path.sep.join(temp_path)

            p = self.gv.create_dirs_recursive(project_path)

            file_path = p + os.path.sep + ff
            shutil.copy2(temp_file, file_path)
            if len(project_files) == file_id:
                shutil.rmtree(os.path.join(ppath, uid))

        else:
            temp_path.append(file_prefix + '.' + out_type)
            temp_file = os.path.sep.join(temp_path)
            p = self.gv.create_dirs_recursive(project_path)

            if os.path.isfile(temp_file):
                file_path = p + os.path.sep + file_prefix + '.' + out_type
                os.rename(temp_file, file_path)
                shutil.rmtree(os.path.join(ppath, uid))
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_OUTPUT_FILE_WAS_NOT_CREATED)
        if len(project_files) == int(file_id):
            print p

        return os.path.sep.join(project_path)


def main():
    pre_process_instance = PreProcess()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
