# -*- coding: utf-8 -*-
# Copyright 13-October-2016, 14:51:07
#
# Author    : Dulip Withanage , University of Heidelberg
import sys
from termcolor import colored


class Debuggable(object):

    def __init__(self, module_name):
        self.module_name = module_name


class Debug(object):

    def __init__(self):
        '''   Initialise this debug instance '''
        self.debug = False

    def enable_debug(self):
        """
        Enables debugging. Is generally  set by Module initialisation

        """
        self.debug = True

    def print_debug(self, module, message):
        """
        Print debug message

        Parameters
        ----------
        module: python module
             Returns the name of the module
        message: str
            message as a string

        See Also
        --------
        print_()

        """

        if self.debug:
            if not isinstance(message, unicode):
                self.fatal_error(
                    self, u'A non unicode string was passed to the debugger')
            self.print_(module, message)

    def print_console(self, module, message):
        """
        Print debug message

        Parameters
        ----------
        module: python module
             Returns the name of the module
        message: str
            message as a string

        See Also
        --------
        print_()

        """
        print(u'[{0}] {1}'.format(colored(module.get_module_name(), 'green'), unicode(message)))

    def print_(self, module, message):
        """
        Prints a formatted message

        Parameters
        ----------
        module: python module
             Returns the name of the module
        message: str
            message as a string

        Returns
        -------
        message :str
            Formatted Message , [Module name] message

        See Also
        --------
        module.get_module_name()
        """
        print(u'[{0}] {1}'.format(module.get_module_name(), unicode(message)))

    def get_module_name(self):
        """
        Reads the name of the module for debugging and logging

        Returns
        -------
        name :string
         Name of the Module

        """
        return 'Debugger'

    @staticmethod
    def fatal_error(module, message):
        """
        Prints a formatted error message and exits

        Parameters
        ----------
        module: python module
             Returns the name of the module
        message: str
            Error message


        See Also
        --------
        module.get_module_name()

        """

        print(u'[{0}] {1} {2}'.format(colored(module.get_module_name(), 'red'),'[FATAL ERROR]', unicode(message)))
        sys.exit(1)
