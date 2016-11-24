#!/usr/bin/env python   ,
# -*- coding: utf-8 -*-
"""
Main  program which  initializes the  Monograph  Publication Tool , read the configuration from the json file.
Configuration json file is organized into projects and typesetters. Each project may contain a set of files ordered and
a ordered subset of typesetters.  Typesetter and file arguments can be specifically configured in a pre-defined order.
A specific project can be configured to run in a chain modus, which  takes the output of the previous typesetter as the input for
the current typesetter. If chaining is not set, all the typesetters take the set of files and execute the typesetter and
generate the output.


Usage:
    preProcess.py  <config_file> [options]
Options:
    -d, --debug  Enable debug output

Example
--------
python /usr/local/mpt/static/tools/mpt.py /home/wit/mpt.json  --debug



* Web : https://github.com/withanage/mpt
* Repository and issue-tracker: https://github.com/withanage/mpt/issues
* Licensed under terms of GPL 3  license (LICENSE.md)

Notes
-------
This program may be used to consolidate output files, generated from a certain tool.  But a consolidation tool should
be set as the last tool in a process chain.

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


class MPT(Debuggable):
    """
    MPT Class Object,  which initializes the properties.

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
        """
        Runs the MPT  Module, which typesets all the projects defined in the json input file

        Returns
        --------
        True: boolean
            Returns True if all the projects are typeset

        """
        self.typeset_all_projects()
        return True

    @staticmethod
    def read_command_line():
        """
        Reads and  generates a docopt dictionary from the command line parameters.

        Returns
        -------
        docopt : dictionary
          A dictionary, where keys are names of command-line elements  such as  and values are theparsed values of those
          elements.
        """
        return docopt(__doc__, version='mpt 0.1')

    def get_module_name(self):
        """
        Reads the name of the module for debugging and logging

        Returns
        -------
        name string
         Name of the Module
        """
        name = 'Monograph Publication Tool'
        return name

    def call_typesetter(self, args):
        """Runs  typesetter with given arguments

        Creates the execution path for a typesetter or an application and runs it  as a system process. Output,
        exit-code and  system error codes are captured and returned.


        Parameters
        ----------
        args : list
            application arguments in the correct oder.


        Returns
        -------
        output :str
            system standard output.
        err :str
            system standard error.
        exit_code: str
            system exit_code.


        """
        m = ' '.join(args).strip().split(' ')
        self.debug.print_debug(self, ' '.join(m))
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        return output, err, exit_code

    def arguments_parse(self, t_props):
        """
        Reads typesetter properties from json  configuration and create  arguments.


        Parameters
        ----------
        t_props : dictionary
            typesetter properties


        Returns
        -------
        args : list
            application execution path and arguments in the correct oder.

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

    def create_output_path(
            self,
            p,
            p_id,
            args,
            prefix,
            uid):
        """
        Creates the output path for  the current file

        Output folder is  constructed using project_name, current_time,  sequence number of the current typesetter
        and the sequence number of the current file.

        Parameters
        ---------
        p: dictionary
            json program properties
        p_id:  int
            typesetter id
        args : list
            application arguments in the correct oder.
        prefix: str
            file name prefix  of  the current file
        uid: str
            unique id of the current current typesetter
        Returns
        --------
        True: boolean
            Returns True if the output file is created
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
                        prefix +
                        '.' +
                        out_type))
            else:
                args.append(arg)
        return True

    def run_typesetter(
            self,
            p,
            pre_path,
            pre_out_type,
            p_id,
            uid,
            f_id,
            f_name,
            args):
        """
        Creates the temporary output path, calls the typesetter and writes the outtput to the correct path for a
        certain file

        Parameters
        ---------
        p: dictionary
            json program properties
        pre_path: str
            project path of the previous iteration
        pre_out_type : str
            output type of the previous iteration
        p_id:  int
            typesetter id
        uid: str
            unique id of the current current typesetter
        f_id:  int
              sequence number of the current file
        f_name:  str
              name of the current file
        args : list
            application arguments in the correct oder.

        Returns
        --------
        p_path : str
            project output path of the current typesetter
        pf_type : str
            project file type of the current typesetter

        See Also
        --------

        call_typesetter, organize_output

        """

        p_path = ''
        pf_type = ''
        prefix = f_name.split('.')[0]
        if p_id == min(i for i in p['typesetters']):
            f_path = os.path.join(p.get('path'), f_name)

        elif p.get("chain"):
            f_path = os.path.join(
                pre_path,
                prefix +
                '.' +
                pre_out_type)

        if os.path.isfile(f_path):
            args.append(f_path)
            self.create_output_path(
                p,
                p_id,
                args,
                prefix, uid)
            self.call_typesetter(args)
            p_path = self.organize_output(
                p,
                p_id,
                prefix,
                f_id,
                uid)

            pf_type = p.get('typesetters')[p_id].get("out_type")

        else:
            self.debug.print_debug(
                self,
                self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST + ' ' +
                os.path.join(f_path))

        return p_path, pf_type

    def typeset_file(
            self,
            p,
            pre_path,
            pre_out_type,
            p_id,
            uid,
            f_id,
            f_name
    ):
        """
        Typesets the current file

        Parameters
        ---------
        p: dictionary
            json program properties
        pre_path: str
            project path of the previous iteration
        pre_out_type : str
            output type of the previous iteration
        p_id:  int
            typesetter id
        uid: str
            unique id of the current current typesetter
        f_id:  int
              sequence number of the current file
        f_name:  str
              name of the current file
        args: list
            application arguments in the correct oder.

        Returns
        --------
        p_path : str
            project output path of the current typesetter
        pf_type : str
            project file type of the current typesetter


        See Also
        --------
        run_typesetter

        """
        t_props = self.all_typesetters.get(
            p.get('typesetters')[p_id].get("name"))
        p_path, pf_type = '', ''
        if t_props:
            mt = self.arguments_parse(t_props)
            if self.check_program(t_props.get('executable')):
                p_path, pf_type = self.run_typesetter(
                    p,
                    pre_path,
                    pre_out_type,
                    p_id,
                    uid,
                    f_id,
                    f_name,
                    mt)

            else:
                self.debug.print_debug(
                    self, self.gv.TYPESETTER_BINARY_IS_UNAVAILABLE)
        else:
            self.debug.print_debug(
                self, self.gv.PROJECT_TYPESETTER_IS_NOT_AVAILABLE)
        return p_path, pf_type

    def typeset_files(
            self,
            p,
            pre_path,
            pre_out_type,
            pre_id):
        """
        Typeset all files of a  certain project

        Parameters
        ---------
        p: dictionary
            json program properties
        pre_path: str
            project path of the previously executed typesetter
        pre_out_type: str
            project file type of the previously executed typesetter
        pre_id :int
            sequence number of the previously executed file

        Returns
        --------
        p_path : str
            project output path of the current typesetter
        pf_type : str
            project file type of the current typesetter


        See Also
        --------
        typeset_file

        """
        p_path, pf_type = '', ''

        uid = str(uuid.uuid4())[:8]

        project_files = collections.OrderedDict(
            sorted((int(key), value) for key, value in p.get('files').items()))

        for f_id in project_files:
            f_name = project_files[f_id]
            p_path, pf_type = self.typeset_file(
                p,
                pre_path,
                pre_out_type,
                pre_id,
                uid,
                f_id,
                f_name
            )

        return p_path, pf_type

    def typeset_project(self, p):
        """
        Typesets a certain project

        Parameters
        ---------
        p: dictionary
            json program properties

        Returns
        --------
        True: boolean
            Returns True, if  all the typesetters in project has run successfully.


        See Also
        --------
        typeset_files

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
        return True

    def typeset_all_projects(self):
        """
        Typeset all projects defined in the json file

        Returns
        --------
        True: boolean
            Returns True, if the  all the typesetters in project run

        See Also
        --------
        typeset_project

        """
        projects = self.config.get('projects')
        if projects:
            for p in projects:
                self.typeset_project(p)

        else:
            self.debug.print_debug(self, self.gv.PROJECTS_VAR_IS_NOT_SPECIFIED)
        return True

    def check_program(self, p):
        """
        Checks  whether a  the program or typesetter is installed and executable

        Parameters
        ---------
        p: str
            Program path

        Returns
        --------
        None: bool
            Returns None , if  program exists

        """

        def is_exe(f_path):
            """
            Checks whether path is available and executable
            Parameters
            ---------
            f_path: str
                File path

            Returns
            --------
            boolean: bool
                True or False

            """
            return os.path.isfile(f_path) and os.access(f_path, os.X_OK)

        fpath, fname = os.path.split(p)
        if fpath:
            if is_exe(p):
                return p
        else:
            for path in os.environ["PATH"].split(os.pathsep):
                path = path.strip('"')
                exe_file = os.path.join(path, p)
                if is_exe(exe_file):
                    return exe_file

        return None

    def organize_output(
            self,
            p,
            p_id,
            prefix,
            f_id,
            uid):
        """
        Copy the temporary results into the  final project path

        This method reads the temporary results of the current typesetter step and copies them in to the correct output
        folder. Output folder is  constructed using project_name, current_time,  sequence number of the current typesetter
        and the sequence number of the current file.  Customized tool specific actions are also defined and handled here.



        Parameters
        ------------
        p: dict
            json program properties
        p_id:  int
            typesetter id
        prefix: str
            file name prefix  of  the current file
        f_id:  int
              sequence number of the current file
        uid: str
            unique id of the current current typesetter

        Returns
        --------
        project_path: str
            Final path for the current file


        See Also
        --------
        gv.create_dirs_recursive
        
        """
        t_path = [p.get('path'), uid]
        p_path = ''
        t_name = p.get('typesetters')[p_id].get("name")
        files = collections.OrderedDict(sorted(p.get('files').items()))
        out_type = p['typesetters'][p_id]['out_type']
        step_ts = p_id + '_' + t_name

        if t_name == 'metypeset':
            t_path = t_path + ['nlm']

        project_path = [
            p.get('path'),
            p['name'],
            self.current_result,
            step_ts,
            out_type]
        if p['typesetters'][p_id].get('merge'):

            ff = p['typesetters'][p_id].get('arguments')["3"]
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
    main method, initializes the  Monograph  Publication Tool and  runs the configuration

    """
    pre_process_instance = MPT()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
