#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Main  program which  initializes the  Monograph  Publication Tool , read the configuration from the json file.
Configuration json file is organized into projects and typesetters. Each project may contain a set of files ordered and
a ordered subset of typesetters.  Typesetter and file arguments can be specifically configured in a pre-defined order.
A specific project can be configured to run in a chain modus, which  takes the output of the previous typesetter as the input for
the current typesetter. If chaining is not set, all the typesetters take the set of files and execute the typesetter and
generate the output.


Usage:
    mpt.py  <config_file> [options]
Options:
    -d, --debug  Enable debug output

Example
--------

python $BUILD_DIR/static/tools/mpt.py  $BUILD_DIR/static/tools/configurations/example.json


Notes
-------
This program may be used to consolidate output files, generated from a certain tool.  But a consolidation tool should
be set as the last tool in a process chain.


References
----------
* Web : https://github.com/withanage/mpt
* Repository and issue-tracker: https://github.com/withanage/mpt/issues
* Licensed under terms of GPL 3  license (LICENSE.md)


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

SEP = os.path.sep

class MPT(Debuggable):
    """
    MPT Class Object,  which initializes the properties and defines the methods.

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

        See Also
        --------
        typeset_all_projects

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
        return docopt(__doc__, version='mpt 0.0.1')

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

        See Also
        --------
        subprocess.Popen()

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

        See Also
        --------
        os.makedirs()

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
            f_path = os.path.join(pre_path,prefix +'.' + pre_out_type)

        if os.path.isfile(f_path) or p['typesetters'].get(p_id).get('expand'):
            args.append(f_path)
            self.create_output_path( p, p_id,  args, prefix, uid)
            output, err, exit_code = self.call_typesetter(args)
            self.debug.print_debug(self, output.decode('utf-8'))

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
        t_props = self.all_typesetters.get(p.get('typesetters')[p_id].get("name"))
        p_path, pf_type = '',''

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

        uid = str(uuid.uuid4())

        project_files = collections.OrderedDict(
            sorted((int(key), value) for key, value in p.get('files').items()))

        for f_id in project_files:
            f_name = project_files[f_id]
            p_path, pf_type = '', ''
            run_typeset_file = True
            if p.get('typesetters')[pre_id].get("expand"):
                f_name = self.gv.uuid
                if f_id != len(p.get('files')):
                    run_typeset_file = False
            if run_typeset_file:
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
        create_merged_file, gv.create_dirs_recursive

        """
        p_name = p.get('typesetters')[p_id].get("name")
        t_path = [p.get('path'), uid] + ['nlm'] if p_name == 'metypeset' else [p.get('path'), uid]
        out_type = p['typesetters'][p_id]['out_type']
        project_path = [p.get('path'),p['name'], self.current_result, p_id + '_' + p_name,out_type]

        if p['typesetters'][p_id].get('merge'):
            f_path = self.create_merged_file(p, p_id, project_path, t_path)
            if len(p.get('files').items()) == f_id:
                shutil.rmtree(os.path.join(p.get('path'), uid))
        else:
            t_path.append(prefix + '.' + out_type)
            #print t_path
            p_path = self.gv.create_dirs_recursive(project_path)
            print 100*'-'
            temp_path = os.path.dirname(os.path.abspath(SEP.join(t_path)))
            for filename in os.listdir(os.path.dirname(os.path.abspath(SEP.join(t_path)))):
                f_path = '{}{}{}'.format(p_path, SEP, filename)
                if os.path.exists(SEP.join(t_path)):
                    os.rename(SEP.join(t_path), f_path)

            if not p['typesetters'][p_id].get('expand'):
                shutil.rmtree(os.path.join(p.get('path'), uid))

        #self.debug.print_console(self, '{}  {}'.format(self.gv.OUTPUT,f_path))

        return SEP.join(project_path)

    def create_merged_file(self, p, p_id, project_path, t_path):
        """
        Create a combined file from a set of input files

        Parameters
        ------------
        p: dict
            json program properties
        p_id:  int
            typesetter id
        t_path : str
            temporary  output directory
        project_path : str
            system path to be created

        See Also
        --------
        create_named_file()


        """
        t_path.append(self.gv.uuid)
        p_path = self.gv.create_dirs_recursive(project_path)
        f_path = '{}{}{}.xml'.format(p_path,SEP ,self.gv.uuid)
        shutil.copy2(SEP.join(t_path), f_path)
        self.create_named_file(p, p_id, p_path, t_path)
        return f_path

    def create_named_file(self,  p, p_id, p_path ,t_path,):
        """
        Copy  unique file name to a named file

        p: dict
            json program properties
        p_id:  int
            typesetter id
        t_path : str
            temporary  output directory
        p_path : str
            output directory for the current typesetter

        """
        f = p['typesetters'][p_id].get('out_file')
        if f:
            f_path = '{}{}{}'.format(p_path, SEP,f)
            shutil.copy2(SEP.join(t_path), f_path)
        return


def main():
    """
    main method, initializes the  Monograph  Publication Tool and  runs the configuration

    See Also
    --------
    run

    """
    pre_process_instance = MPT()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
