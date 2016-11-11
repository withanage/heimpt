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
    """
    converts  source files into xml using the typesetter module
    """

    def __init__(self):

        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()

        self.current_result = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-") + str(uuid.uuid4())[:8]
        self.config = self.gv.read_json(self.args['<config_file>'])
        self.all_typesetters = self.config.get('typesetters')

    def run(self):
        self.typeset_all_projects()
        return

    @staticmethod
    def read_command_line():
        """
        Reads and evaluates command line
        :return:
        """
        return docopt(__doc__, version='mpt 0.1')

    def get_module_name(self):
        """
        Reads the name of the module for debugging and logging
        :return:
        """
        return 'Monograph Publishing Tool'

    def call_typesetter(self, tool_args):
        """
        Call a tool with given arguments
        :param tool_args:
        :return:
        """
        m = ' '.join(tool_args).strip().split(' ')
        self.debug.print_debug(self, ' '.join(m))
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        return output, err, exit_code

    def arguments_parse(self, t_props):
        """
        reads typesetter properties and create the arguments
        :param t_props:
        :return: args
        """
        args = []
        if t_props.get('executable'):
            args = [t_props.get('executable')]
        else:
            self.debug.print_debug(
                self, self.gv.TYPESETTER_EXECUTABLE_VARIABLE_IS_UNDEFINED)
            sys.exit(1)
        arguments = t_props.get("arguments")
        if arguments:
            arguments = collections.OrderedDict(sorted(arguments.items()))
            for a in arguments:
                args.append(arguments[a])
        return args

    def create_execution_path(
            self,
            project,
            project_typesetter_id,
            mt,
            file_prefix,
            uid):
        """
        creates the full execution path for a file
        :param project:
        :param project_typesetter_id:
        :param mt:
        :param file_prefix:
        :param uid:
        :return:
        """
        project_typesetter_arguments = collections.OrderedDict(
            sorted(project.get('typesetters')[project_typesetter_id].get("arguments").items()))
        project_typesetter_out_type = project.get('typesetters')[project_typesetter_id].get("out_type")
        project_typesetter_out_path = os.path.join(project.get('path'), uid)

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
            previous_project_path,
            previous_project_typesetter_out_type,
            project_typesetter_id,
            uid,
            file_id,
            args):
        """
        Runs  the typesetter
        :param project:
        :param previous_project_path:
        :param previous_project_typesetter_out_type:
        :param project_typesetter_id:
        :param uid:
        :param file_id:
        :param args:
        :return:
        """
        previous_project_path_temp = ''
        temp = ''

        project_files = collections.OrderedDict(sorted(project.get('files').items()))
        file_prefix = project_files[file_id].split('.')[0]
        if project_typesetter_id == min(i for i in project['typesetters']):
            file_path = os.path.join(project.get('path'), project_files[file_id])
        elif project.get("chain"):
            file_path = os.path.join(
                previous_project_path,
                file_prefix +
                '.' +
                previous_project_typesetter_out_type)
        if os.path.isfile(file_path):
            args.append(file_path)
            self.create_execution_path(
                project,
                project_typesetter_id,
                args,
                file_prefix, uid)
            output, err, exit_code = self.call_typesetter(args)
            previous_project_path_temp = self.organize_output(
                project,
                project_typesetter_id,
                file_prefix,
                file_id,
                uid)

            temp = project.get('typesetters')[project_typesetter_id].get("out_type")

        else:
            self.debug.print_debug(
                self,
                self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST +
                os.path.join(file_path))
        return previous_project_path_temp, temp

    def typeset_file(
            self,
            project,
            previous_project_path,
            previous_project_typesetter_out_type,
            project_typesetter_id,
            uid,
            file_id):
        """
        Typesets a certain file
        :param project:
        :param previous_project_path:
        :param previous_project_typesetter_out_type:
        :param project_typesetter_id:
        :param uid:
        :param file_id:
        :return:
        """
        typesetter_properties = self.all_typesetters.get(project.get('typesetters')[project_typesetter_id].get("name"))
        previous_project_path_temp, previous_project_typesetter_out_type_temp = '', ''
        if typesetter_properties:
            mt = self.arguments_parse(typesetter_properties)
            if self.check_program(typesetter_properties.get('executable')):
                previous_project_path_temp, previous_project_typesetter_out_type_temp = self.run_typesetter(
                    project,
                    previous_project_path,
                    previous_project_typesetter_out_type,
                    project_typesetter_id,
                    uid,
                    file_id,
                    mt)
            else:
                self.debug.print_debug(
                    self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)
        else:
            self.debug.print_debug(
                self, self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
        return previous_project_path_temp, previous_project_typesetter_out_type_temp

    def typeset_files(
            self,
            project,
            previous_project_path,
            previous_project_typesetter_out_type,
            project_typesetter_id):
        """
        Typeset all files of a  certain project
        :param project:
        :param previous_project_path:
        :param previous_project_typesetter_out_type:
        :param project_typesetter_id:
        :return:
        """
        temp_pre_path, tem_out_type = '', ''

        uid = str(uuid.uuid4())[:8]

        project_files = collections.OrderedDict(sorted(project.get('files').items()))

        for file_id in project_files:
            temp_pre_path, tem_out_type = self.typeset_file(
                project,
                previous_project_path,
                previous_project_typesetter_out_type,
                project_typesetter_id,
                uid,
                file_id
            )

        return temp_pre_path, tem_out_type

    def typeset_project(self, project):
        """
        typesets a certain project
        :param project:
        :return:
        """
        project_typesetters_ordered, pp_path_temp, pp_typesetter_out_type_temp = '', '', ''
        pre_path = ''
        prev_out_type = ''

        if project.get('active'):
            project_typesetters = project.get('typesetters')
            if project_typesetters:
                project_typesetters_ordered = collections.OrderedDict(
                    sorted(project_typesetters.items()))
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED)

            if self.all_typesetters is None:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED)
                sys.exit(1)

            for project_typesetter_id in project_typesetters_ordered:
                pp_path_temp, pp_typesetter_out_type_temp = self.typeset_files(
                    project,
                    pre_path,
                    prev_out_type,
                    project_typesetter_id
                )

                pre_path = pp_path_temp
                prev_out_type = pp_typesetter_out_type_temp
        else:
            self.debug.print_debug(self, self.gv.PROJECT_IS_NOT_ACTIVE)

    def typeset_all_projects(self):
        """
        Typeset all projects
        :return:
        """
        projects = self.config.get('projects')
        if projects:
            for p in projects:
                self.typeset_project(p)

        else:
            self.debug.print_debug(self, self.gv.PROJECTS_VAR_IS_NOT_SPECIFIED)

    def check_program(self, program):
        """
        Checks if a  the program is installed and executable
        :param program:
        :return:
        """
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

    def organize_output(
            self,
            project,
            typesetter_id,
            file_prefix,
            file_id,
            uid):
        """
        Copy the temporary results into the  correct project path
        :param project:
        :param typesetter_id:
        :param file_prefix:
        :param file_id:
        :param uid:
        :return:
        """
        temp_path = [project.get('path'), uid]
        project_path, p = '', ''
        typesetter_name = project.get('typesetters')[typesetter_id].get("name")
        project_files = collections.OrderedDict(sorted(project.get('files').items()))

        if typesetter_name == 'metypeset':
            temp_path = temp_path + ['nlm']
        out_type = project['typesetters'][typesetter_id]['out_type']
        project_path = [
            project.get('path'),
            project['name'],
            self.current_result,
            typesetter_id + '_' + typesetter_name,
            out_type]
        if project['typesetters'][typesetter_id].get('merge'):
            ff = project['typesetters'][typesetter_id].get('arguments')["3"]
            temp_path.append(ff)
            temp_file = os.path.sep.join(temp_path)

            p = self.gv.create_dirs_recursive(project_path)

            file_path = p + os.path.sep + ff
            shutil.copy2(temp_file, file_path)
            if len(project_files) == file_id:
                shutil.rmtree(os.path.join(project.get('path'), uid))

        else:
            temp_path.append(file_prefix + '.' + out_type)
            temp_file = os.path.sep.join(temp_path)
            p = self.gv.create_dirs_recursive(project_path)

            if os.path.isfile(temp_file):
                file_path = p + os.path.sep + file_prefix + '.' + out_type
                os.rename(temp_file, file_path)
                shutil.rmtree(os.path.join(project.get('path'), uid))
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_OUTPUT_FILE_WAS_NOT_CREATED)
        if len(project_files) == int(file_id):
            print p

        return os.path.sep.join(project_path)


def main():
    """
    main method, initializes the Pre Proecess and  runs the configuration
    :return:
    """
    pre_process_instance = PreProcess()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
