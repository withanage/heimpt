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
import sys
import shutil
import uuid
import datetime
from globals import GV
from debug import Debuggable, Debug
from docopt import docopt
from subprocess import Popen, PIPE
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

        self.current_result = datetime.datetime.now().strftime(
            "%Y_%m_%d-%H-%M-") + str(uuid.uuid4())[:8]
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
            p,
            p_id,
            args,
            file_prefix,
            uid):
        """
        creates the full execution path for a file
        :param p:
        :param p_id:
        :param args:
        :param file_prefix:
        :param uid:
        :return:
        """
        ts_args = collections.OrderedDict(
            sorted(p.get('typesetters')[p_id].get("arguments").items()))
        out_type = p.get('typesetters')[p_id].get("out_type")
        out_path = os.path.join(p.get('path'), uid)

        for i in ts_args:
            arg = ts_args[i]
            if arg == 'fn:append_out_dir':
                args.append(out_path)
            elif arg == 'fn:create_out_file':
                if not os.path.exists(out_path):
                    os.makedirs(out_path)
                args.append(
                    os.path.join(
                        out_path,
                        file_prefix +
                        '.' +
                        out_type))
            elif arg == 'fn:metypeset-meta':
                pth = os.path.join(
                    p.get('path'),
                    file_prefix +
                    '.book-part-meta.bits.xml')
                if os.path.exists(pth):
                    args.append('--metadata')
                    args.append(pth)
                else:
                    self.debug.print_debug(
                        self, self.gv.TYPESETTER_METYPESET_RUNS_WITH_DEFAULT_METADATA_FILE)

            else:
                args.append(arg)

    def run_typesetter(
            self,
            p,
            pre_path,
            pre_out_type,
            p_id,
            uid,
            file_id,
            args):
        """
        Runs  the typesetter
        :param p:
        :param pre_path:
        :param pre_out_type:
        :param p_id:
        :param uid:
        :param file_id:
        :param args:
        :return:
        """
        previous_project_path_temp = ''
        temp = ''

        files = collections.OrderedDict(sorted(p.get('files').items()))
        prefix = files[file_id].split('.')[0]
        if p_id == min(i for i in p['typesetters']):
            file_path = os.path.join(p.get('path'), files[file_id])
        elif p.get("chain"):
            file_path = os.path.join(
                pre_path,
                prefix +
                '.' +
                pre_out_type)
        if os.path.isfile(file_path):
            args.append(file_path)
            self.create_execution_path(
                p,
                p_id,
                args,
                prefix, uid)
            output, err, exit_code = self.call_typesetter(args)
            previous_project_path_temp = self.organize_output(
                p,
                p_id,
                prefix,
                file_id,
                uid)

            temp = p.get('typesetters')[p_id].get("out_type")

        else:
            self.debug.print_debug(
                self,
                self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST +
                os.path.join(file_path))
        return previous_project_path_temp, temp

    def typeset_file(
            self,
            project,
            pre_path,
            pre_out_type,
            p_id,
            uid,
            file_id):
        """
        Typesets a certain file
        :param project:
        :param pre_path:
        :param pre_out_type:
        :param p_id:
        :param uid:
        :param file_id:
        :return:
        """
        t_props = self.all_typesetters.get(
            project.get('typesetters')[p_id].get("name"))
        temp_pre_path, temp_pre_out_type = '', ''
        if t_props:
            mt = self.arguments_parse(t_props)
            if self.check_program(t_props.get('executable')):
                temp_pre_path, temp_pre_out_type = self.run_typesetter(
                    project,
                    pre_path,
                    pre_out_type,
                    p_id,
                    uid,
                    file_id,
                    mt)
            else:
                self.debug.print_debug(
                    self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)
        else:
            self.debug.print_debug(
                self, self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
        return temp_pre_path, temp_pre_out_type

    def typeset_files(
            self,
            project,
            pre_path,
            pre_out_type,
            pre_id):
        """
        Typeset all files of a  certain project
        :param project:
        :param pre_path:
        :param pre_out_type:
        :param pre_id:
        :return:
        """
        temp_pre_path, tem_out_type = '', ''

        uid = str(uuid.uuid4())[:8]

        project_files = collections.OrderedDict(
            sorted(project.get('files').items()))

        for file_id in project_files:
            temp_pre_path, tem_out_type = self.typeset_file(
                project,
                pre_path,
                pre_out_type,
                pre_id,
                uid,
                file_id
            )

        return temp_pre_path, tem_out_type

    def typeset_project(self, p):
        """
        typesets a certain project
        :param p:
        :return:
        """
        typesetters_ordered, temp_path, temp_pre_out_type = '', '', ''
        pre_path = ''
        prev_out_type = ''

        if p.get('active'):
            ts = p.get('typesetters')
            if ts:
                typesetters_ordered = collections.OrderedDict(
                    sorted(ts.items()))
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTERS_ARE_NOT_SPECIFIED)

            if self.all_typesetters is None:
                self.debug.print_debug(
                    self, self.gv.PROJECT_TYPESETTER_VAR_IS_NOT_SPECIFIED)
                sys.exit(1)

            for p_id in typesetters_ordered:
                temp_path, temp_pre_out_type = self.typeset_files(
                    p,
                    pre_path,
                    prev_out_type,
                    p_id
                )

                pre_path = temp_path
                prev_out_type = temp_pre_out_type
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
            p,
            t_id,
            prefix,
            f_id,
            uid):
        """
        Copy the temporary results into the  correct project path
        :param p:
        :param t_id:
        :param prefix:
        :param f_id:
        :param uid:
        :return:
        """
        t_path = [p.get('path'), uid]
        p_path = ''
        t_name = p.get('typesetters')[t_id].get("name")
        files = collections.OrderedDict(sorted(p.get('files').items()))
        out_type = p['typesetters'][t_id]['out_type']
        step_ts = t_id + '_' + t_name

        if t_name == 'metypeset':
            t_path = t_path + ['nlm']

        project_path = [
            p.get('path'),
            p['name'],
            self.current_result,
            step_ts,
            out_type]
        if p['typesetters'][t_id].get('merge'):

            ff = p['typesetters'][t_id].get('arguments')["3"]
            t_path.append(ff)
            t_file = os.path.sep.join(t_path)
            p_path = self.gv.create_dirs_recursive(project_path)
            f_path = p_path + os.path.sep + ff
            shutil.copy2(t_file, f_path)
            if len(files) == f_id:
                shutil.rmtree(os.path.join(p.get('path'), uid))

        else:
            t_path.append(prefix + '.' + out_type)
            t_file = os.path.sep.join(t_path)
            p_path = self.gv.create_dirs_recursive(project_path)

            if os.path.isfile(t_file):
                f_path = p_path + os.path.sep + prefix + '.' + out_type
                os.rename(t_file, f_path)
                shutil.rmtree(os.path.join(p.get('path'), uid))
            else:
                self.debug.print_debug(
                    self, self.gv.PROJECT_OUTPUT_FILE_WAS_NOT_CREATED)

        if len(files) == int(f_id):
            print p_path

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
