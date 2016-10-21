#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    xmlProcess.py  <config_file> [options]
Options:
    -d, --debug                                     Enable debug output
"""

__author__ = "Dulip Withnage"

PYTHON_IMPORT_FAILED_LXML_MODULE= u'Failed to import python lxml module'

import sys , globals
from debug import Debuggable, Debug
from docopt import docopt
from globals import GV


try:
    from lxml import etree
    from lxml import objectify
except ImportError:
    print(PYTHON_IMPORT_FAILED_LXML_MODULE)
    sys.exit(1)
    
class xmlProcess(Debuggable):
    '''     command line tool to clean, modify, delete, merge jats files    '''
    def __init__(self):
        self.args = self.read_command_line()
        self.gv = GV()
        
    
    @staticmethod
    def read_command_line():
        return docopt(__doc__, version='xml 0.1')
    
        
if __name__ == '__main__':
    pass