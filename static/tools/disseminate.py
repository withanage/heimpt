#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Reads a xml file , transforms it to a intermediate format (e.g. formattion objects: FO ) and converts  to PDF subsequently


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


class Disseminate(Debuggable):

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
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

        s = os.path.join(self.script_path, 'meTypeset/runtime/saxon9.jar')
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
        self.gv.create_dirs_recursive(self.dr.split('/'))

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
        create_fo, create_pdf

        """
        if self.out_type == 'fo':
            self.create_fo()

        if self.out_type == 'pdf':
            self.create_pdf()

    def create_pdf(self):
        s = os.path.join(self.script_path, 'fop/fop')
        args=[s]
        if os.path.isfile(s):
            formatters = self.args.get('--formatter').split(',')
            mediums = self.args.get('--medium').split(',')
            for f in formatters:
                for m in mediums:
                    self.debug.print_console(self, self.gv.RUNNING_PDF_CONVERSION)
                    self.gv.create_dirs_recursive(self.args.get('<path>').split(os.pathsep))
                    output, err, exit_code = self.process(args)

        else:
            self.debug.print_debug(self, self.gv.PROJECT_FO_PROCESSOR_DOES_NOT_EXIST+' '+ s)
        return

    def create_fo(self):
        """
        Create  FO output


        See Also
        -------
        run_saxon(), get_saxon_path()
        """

        saxon_path = self.get_saxon_path()
        if not saxon_path:
            self.debug.print_debug(self, self.gv.SAXON_IS_NOT_AVAILABLE)
            sys.exit(1)
        else:
            formatters = self.args.get('--formatter').split(',')
            mediums = self.args.get('--medium').split(',')
            for f in formatters:
                for m in mediums:
                    self.debug.print_console(self, self.gv.RUNNING_FO_CONVERSION)
                    self.gv.create_dirs_recursive(self.args.get('<path>').split(os.pathsep))
                    args = self.run_saxon(saxon_path,f, m)
                    self.process(args)

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
        args.append('formatter=' + formatter)
        args.append('medium=' + medium)



        return args


"""
bin/fop/fop -fo Testdokument_print_fop.fo
-pdf Testdokument_print_fop.pdf -c
conf/fop-print.xml
-pdfprofile PDF/X-3:2003


/bin/xep/xep
-fo /Volumes/DATENSTICK/14\ XSL-FO/out/fo/Testdokument_epdf_xep.fo
-pdf /Volumes/DATENSTICK/14\ XSL-FO/out/pdf/Testdokument_epdf_xep.pdf

/usr/local/AHFormatterV63/run.sh
-d /Volumes/DATENSTICK/14\ XSL-FO/out/fo/Testdokument_epdf_ah.fo
-o /Volumes/DATENSTICK/14\ XSL-FO/out/pdf/Testdokument_epdf_ah.pdf
"""


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
