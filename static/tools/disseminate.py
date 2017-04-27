#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Reads a xml file , transforms it to a intermediate format (e.g. formatting objects: FO ) and converts  to PDF subsequently


Usage:
    disseminate.py  <input_file>  <path>  --out-type=<FO_PDF> [options]
Options:
    -d, --debug  Enable debug output
    -f --formatter=<electronic_or_print>    Formatter
    -m --medium=<filename>    Stylesheet file
    -s --saxon=<location_of_the_saxon_jar_file>
    -x --xsl=<filename>    Stylesheet file



Example
--------

python $BUILD_DIR/static/tools/disseminate.py


"""

__author__ = "Dulip Withanage"

from debug import Debuggable, Debug
from globals import GV
import sys
import os
import inspect
from docopt import docopt
from subprocess import Popen, PIPE
from settingsconfiguration import Settings


class Disseminate(Debuggable):

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.settings = Settings(self.args)
        self.gv = GV(self.settings)
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()
        self.dr = self.args.get('<path>')
        self.f = self.args.get('<input_file>')
        self.out_type = self.args.get('--out-type').lower()
        self.script_path = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

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
        return docopt(__doc__, version='Disseminate 0.1')



    def get_saxon_path(self):
        """Checks if saxon is available in the default path

        Returns
        --------
        saxon : boolean
            True, if saxon is available. False, if not.

        """

        s = os.path.join(self.script_path, self.gv.apps.get('saxon'))
        if os.path.isfile(s):
            return s
        elif self.args.get('--saxon'):
            if os.path.isfile(self.args.get('--saxon')):
                return self.args.get('--saxon')
            else:
                return False

        else:
            return False

    def get_module_name(self):
        """
        Reads the name of the module for debugging and logging

        Returns
        -------
        name string
         Name of the Module
        """
        name = 'OUTPUT Generation'
        return name

    def process(self, args):
        """Runs  typesetter with given arguments

        Creates the execution path for  the conversion process. Output,exit-code and  system error codes are captured and returned.


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
        print ' '.join(args)
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        if exit_code == 1:
            print err
            sys.exit(1)
        return output, err, exit_code

    def run(self):
        """
        Runs converters

        See Also
        --------
        create_output, create_pdf

        """
        self.create_output(self.out_type)


    def create_output(self, out_type):
        """
        Create  FO output

        Parameters
        ----------
        out_type: str
            Output Type


        See Also
        -------
        run_saxon(), get_saxon_path()
        """

        formatters = self.args.get('--formatter').split(',')
        mediums = self.args.get('--medium').split(',')
        for f in formatters:
            f = f.lower()
            for m in mediums:
                m = m.lower()
                self.gv.create_dirs_recursive(self.args.get('<path>').split(os.pathsep))
                if self.out_type=='fo':
                    self.debug.print_console(self, self.gv.RUNNING_FO_CONVERSION)
                    saxon_path = self.get_saxon_path()
                    args = self.run_saxon(saxon_path,f, m)
                if self.out_type=='pdf':
                    self.debug.print_console(self, self.gv.RUNNING_PDF_CONVERSION)
                    args = self.run_fop_processor(f, m)
                output, err, exit_code = self.process(args)
                print output

    def run_fop_processor(self,  formatter, medium):

        args = []
        if formatter.lower() == 'fop':
            pth = os.path.join(self.script_path, self.gv.apps.get('fop'))
            if self.gv.check_program(pth):
                args = self.run_apache_fop(pth,formatter, medium)

        elif formatter.lower() == 'ah':
            pth = self.gv.apps.get('ah')
            if self.gv.check_program(pth):
                args = self.run_ah_fop(pth,formatter, medium)
        return args

    def run_ah_fop(self, pth, formatter, medium):
        args=[pth]
        args.append('-d')
        args.append('{}/{}.{}.{}.fo'.format(os.path.dirname(self.f), self.gv.uuid, formatter, medium))
        args.append('-o')
        args.append('{}/{}.{}.{}.pdf'.format(self.dr, self.gv.uuid, formatter, medium))

        return args






    def run_apache_fop(self, pth, formatter, medium):
        style_path = '{}/configurations/fop/conf/{}.{}.xml'.format(self.script_path, formatter,medium)
        args = [pth]
        args.append('-fo')
        args.append('{}/{}.{}.{}.fo'.format(os.path.dirname(self.f),self.gv.uuid, formatter, medium))
        args.append('-pdf')
        args.append('{}/{}.{}.{}.pdf'.format(self.dr,self.gv.uuid, formatter, medium))
        args.append('-c')
        args.append(style_path)
        return args



    def run_saxon(self, saxon_path, formatter, medium):
        """
        Creates the executable path for saxon

        Parameters
        ---------
        saxon_path : str
            absolute path  of the saxon binary jar file
        formatter : str
            name of the FO formatter
        medium : str
            name of the medium

        Returns
        ------
        args:list
            List of arguments for saxon execution path

        """
        args = ["java", "-jar", saxon_path]
        if self.args.get('--xsl'):
            xsl = self.script_path.split(os.sep)[:-1]
            xsl.append('stylesheets')
            xsl.append(self.args.get('--xsl'))
            args.append("-xsl:" + os.sep.join(xsl))

        s = self.args.get('<input_file>')
        if os.path.exists(s):
            args.append("-s:" + s)
        else:
            self.debug.print_debug(self, self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST + ' ' + s)
            sys.exit(1)
        file_name = '.'.join([self.gv.uuid,formatter.lower(),medium.lower(),'fo'])
        args.append("-o:" + os.path.join(self.args.get('<path>'), file_name))
        args.append('formatter=' + formatter.lower())
        args.append('medium=' + medium.lower())


        return args




def main():
    """
    Calls the conversion process

    See Also
    --------
    run

    """

    xp = Disseminate()
    xp.run()


if __name__ == '__main__':
    main()
