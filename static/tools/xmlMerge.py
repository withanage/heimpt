#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    xmlMerge.py  <input_file>  <path>  <scheme> <output_file>  [options]
    xmlMerge.py -h --help
Options:
    -d, --debug   Enable debug output
    --header-file

"""


__author__ = "Dulip Withnage"

PYTHON_IMPORT_FAILED_LXML_MODULE = u'Failed to import python lxml module'

import os
import sys
import uuid
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
        print self.args
        self.debug = Debug()
        self.gv = GV()
        self.uid = '4e4dd8cf-26bf-4893-b037-1fd3bf08f112'
        self.dr = self.args.get('<path>')
        self.schema = self.args.get('<scheme>')
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()

    @staticmethod
    def read_command_line():

        return docopt(__doc__, version='xml 0.1')

    def xml_elements_to_array(self, xpath_expression, root):

        elem_array = []
        try:
            for i in root.findall(xpath_expression):
                elem_array.append(etree.tostring(i, pretty_print=False))
        except SyntaxError as se:
            print se
        return elem_array

    def get_front(self, fl):

        hf = self.args.get('--header-file')
        if hf:
            f = open(self.uid + 'front.xml')
            s = f.read()
            f.close()
            return s
        else:
            return fl

    def write_array_to_file(self, f, name):
        p = self.get_tmp_file_name(name)
        t = open(os.path.join(self.dr, ''.join(p)), 'w')
        for i in f:
            t.write(i)
        t.close()

    def get_tmp_file_name(self, name):
        ''' get temporary file name '''
        p = [self.uid, '.', self.schema, '.', name, '.xml']
        return p

    def create_temp_files(self, front, body, back):
        ''' create   temp files for jats format '''
        self.write_array_to_file(front, 'front')
        self.write_array_to_file(body, 'body')
        self.write_array_to_file(back, 'back')

    def create_output(self, tr):
        ''' create ouput file'''
        root = tr.getroot()
        front = self.xml_elements_to_array(".//front", root)
        body = self.xml_elements_to_array(".//body", root)
        back = self.xml_elements_to_array(".//back", root)

        if front and body and back:
            front = self.get_front(front)
            p = self.get_tmp_file_name('bodys')
            try:
                f = os.path.join(self.dr, ''.join(p))
                open(f, 'r')
            except IOError as i:
                self.debug.print_debug(self, self.gv.XML_INPUT_FILE_IS_NOT_FOUND)
                sys.exit(1)

            self.create_temp_files(front, body, back)
        else:
            self.debug.print_debug(self, self.gv.XML_INPUT_FILE_IS_NOT_VALID)
            sys.exit(1)

        return tr

    def process_xml_file(self):

        f = self.args.get('<input_file>')
        o = self.args.get('<output_file>')
        tr = etree.parse(os.path.join(self.dr, f))
        count = 1
        range_count = [1, 2]
        self.gv.create_dirs_recursive(self.dr.split('/'))
        tr = self.create_output(tr)
        print o
        self.gv.create_xml_file(tr, os.path.join(self.dr, os.path.basename(o)))

    def run(self):
        self.process_xml_file()


def main():

    xp = XMLProcess()
    xp.run()
    


if __name__ == '__main__':
    main()
