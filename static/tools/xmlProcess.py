#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    xmlProcess.py  <input_file>  <path> [options] 
Options:
    -d, --debug                                     Enable debug output
"""


__author__ = "Dulip Withnage"

PYTHON_IMPORT_FAILED_LXML_MODULE= u'Failed to import python lxml module'

import os, sys 
from debug import Debuggable, Debug
from docopt import docopt
from globals import GV


try:
    from lxml import etree
    from lxml import objectify
except ImportError:
    print(PYTHON_IMPORT_FAILED_LXML_MODULE)
    sys.exit(1)
    
class XMLProcess(Debuggable):
    '''     command line tool to clean, modify, delete, merge jats files    '''
    
    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()
        print self.args

    
    @staticmethod
    def read_command_line():
        return docopt(__doc__, version='xml 0.1')
    
    
    

    def xml_elements_to_array(self,xpath_expression, root):
        print xpath_expression
        elem_array = []
        for i in root.findall(xpath_expression):
            elem_array.append(etree.tostring(i, pretty_print=False))
        return elem_array

    def process_xml_file(self):
        dr = self.args.get('<path>')
        f = self.args.get('<input_file>')
        
        tr = etree.parse(os.path.join(dr, f))
        self.gv.create_xml_file(tr, os.path.join(dr, f))
        root = tr.getroot()
        front = self.xml_elements_to_array(".//front",  root) 
        body_secs = self.xml_elements_to_array(".//body/sec",  root)
        back_fns = self.xml_elements_to_array(".//back/fn-group/fn",  root)
        back_refs = self.xml_elements_to_array(".//back/ref-list/ref", root)
        back_fn_group = self.xml_elements_to_array(".//back/fn-group",  root)
        
        print front
        return 
    
    def run(self):
        self.process_xml_file()
        
def main():
    xp = XMLProcess()
    xp.run()
    
    
   
if __name__ == '__main__':
    main()