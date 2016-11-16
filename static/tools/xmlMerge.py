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
    """
      command line tool to clean, modify, delete, merge jats files
    """

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
        self.uid = '4e4dd8cf-26bf-4893-b037-1fd3bf08f112'
        self.dr = self.args.get('<path>')
        self.schema = self.args.get('<scheme>')
        self.o = self.args.get('<output_file>')
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()

    @staticmethod
    def read_command_line():
        """
        Reads and evaluates command line
        :return:
        """
        return docopt(__doc__, version='xml 0.1')

    def get_children(self, xpath_expression, root):
        """
        get element children  as array
        :param xpath_expression:
        :param root:
        :return:
        """

        e = []
        try:
            for i in root.findall(xpath_expression):
                for child in i.getchildren():
                    e.append(etree.tostring(child, pretty_print=False))
        except SyntaxError as se:
            print se
        return e

    def get_front(self, fl):

        hf = self.args.get('--header-file')
        if hf:
            f = open(self.uid + 'front.xml')
            s = f.read()
            f.close()
            return s
        else:
            return fl






    def create_output_bits(self, tr):
        """
        create bits output file
        :param tr:
        :return:
        """
        l = self.create_book_part(tr)
        fuf = os.path.join(self.dr, self.o)
        pt = os.path.join(self.dr, os.path.basename(self.o))
        print pt
        if os.path.isfile(fuf):
            trf = etree.parse(fuf)
            print trf
        else:
            k = ['<book>','<book-metadata>','</book-metadata>']
            m = ['</book>']
            self.do_file_io(''.join(k)+l+''.join(m), 'w', pt)
            self.gv.create_xml_file(tr, pt)


        return tr

    def create_book_part(self, tr):
        r = tr.getroot()
        f = self.get_children(".//front", r)
        bd = self.get_children(".//body", r)
        bk = self.get_children(".//back", r)
        l = ''.join(
            [
                '<book-part>',
                '<book-part-meta>', ''.join(f), '</book-part-meta>',
                '<body>', ''.join(bd), '</body>'
                '<back>', ''.join(bk), '</back>',
                '</book-part>'
            ])
        return l

    def create_output_jats(self, tr):
        """
        create output file
        :param tr:
        :return:
        """
        f, bd, bkfn, bkref = self.get_jats_xml_parts(tr)
        print f
        if f and bd:
            fuf = os.path.join(self.dr, self.o)
            pt = os.path.join(self.dr, os.path.basename(self.o))
            if os.path.isfile(fuf):
                trf = etree.parse(fuf)
                ff, bdf, bkffn, bkfref = self.get_jats_xml_parts(trf)
                print ff
                l = ''.join(
                    ['<article>', '<front>', ''.join(ff),
                     '</front>', '<body>', ''.join(bdf),
                     '<sec>', ''.join(bd),
                     '</sec>', '</body>', '<back>', '<fn-group>',
                     ''.join(bkffn),
                     ''.join(bkfn),
                     '</fn-group>', '<ref-list>', ''.join(bkfref),
                     ''.join(bkref),
                     '</ref-list>', '</back>', '</article>'])
                self.do_file_io(l, 'w', pt)
            else:
                self.gv.create_xml_file(tr, pt)

        else:
            self.debug.print_debug(self, self.gv.XML_INPUT_FILE_IS_NOT_VALID)
            sys.exit(1)

        return tr

    def get_jats_xml_parts(self, tr):
        r = tr.getroot()
        f = self.get_children(".//front", r)
        bd = self.get_children(".//body", r)
        bkfn = self.get_children(".//back/fn-group", r)
        bkref = self.get_children(".//back/ref-list", r)
        return f, bd, bkfn, bkref

    def do_file_io(self, l, mode, p):
        try:
            w = open(p, mode)
            if mode == 'w':
                w.write(l)
                w.close()
                return -1
            if mode == 'r':
                o = w.read()
                w.close()
                return o
        except IOError as i:
            self.debug.print_debug(self, i)
            print(i)
            sys.exit(1)

    def process_xml_file(self):

        f = self.args.get('<input_file>')
        tr = etree.parse(os.path.join(self.dr, f))
        count = 1
        range_count = [1, 2]
        self.gv.create_dirs_recursive(self.dr.split('/'))
        print self.schema
        if self.schema=='jats':
            tr = self.create_output_jats(tr)
        elif self.schema=='bits':

            tr = self.create_output_bits(tr)

    def run(self):
        self.process_xml_file()


def main():

    xp = XMLProcess()
    xp.run()

if __name__ == '__main__':
    main()
