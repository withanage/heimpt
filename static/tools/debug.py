# -*- coding: utf-8 -*-
# Copyright 13-October-2016, 14:51:07
#
# Author    : Dulip Withanage , University of Heidelberg
import sys

class Debuggable(object):

    def __init__(self, module_name):
        self.module_name = module_name


class Debug(object):

    def __init__(self):
        '''   Initialise this debug instance '''
        self.debug = False

    def enable_debug(self):
        self.debug = True

    def print_debug(self, module, message):
        ''' Print debug message '''
        if self.debug:
            if not isinstance(message, unicode):
                self.fatal_error(self, u'A non unicode string was passed to the debugger')
            self.print_(module, message)

    def print_(self, module, message):
        print(u'[{0}] {1}'.format(module.get_module_name(), unicode(message)))

    def get_module_name(self):
        return 'Debugger'
    
    @staticmethod
    def fatal_error(module, message):
        print(u'[FATAL ERROR] [{0}] {1}'.format(module.get_module_name(), message))
        sys.exit(1)
