#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    xmlMerge.py  <input_file>  <path>  <convert-to> <output_file>  [options]
    xmlMerge.py -h --help
Options:
    -d, --debug   Enable debug output
    --header-file

"""


__author__ = "Dulip Withanage"

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
        self.scheme = self.args.get('<convert-to>')
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
                    e.append(etree.tostring(child, pretty_print=True))
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
        fuf = os.path.join(self.dr, self.o)
        pt = os.path.join(self.dr, os.path.basename(self.o))

        if os.path.isfile(fuf):
            trf = etree.parse(fuf)
            bp = trf.find("book-body")
            book_part = self.create_book_part_bits(tr)
            bp.append(book_part)
            self.do_file_io(etree.tostring(trf, pretty_print=True), 'w', pt)

        else:
            book = self.create_book_bits(tr)
            self.do_file_io(etree.tostring(book, pretty_print=True), 'w', pt)

    def create_book_bits(self, tr):
        """
        creates a  bits book part element
        :param tr:
        :return:
        """
        book = etree.Element("book")
        book.append(etree.Element("book-metadata"))
        bd = etree.Element("book-body")
        book_body_parts = self.create_book_part_bits(tr)
        bd.append(book_body_parts)
        book.append(bd)

        return book

    def create_book_part_bits(self, tr):
        f, bd, bk = self.get_jats_xml_parts(tr)
        bp = etree.Element("book-part")
        book_part_meta = etree.Element("book-part-meta")
        book_part_meta.append(f)
        bp.append(book_part_meta)
        bp.append(bd)
        bp.append(bk)
        return bp

    def get_jats_xml_parts(self, tr):
        r = tr.getroot()
        f = r.find(".//front")
        bd = r.find(".//body")
        bk = r.find(".//back")
        return f, bd, bk

    def do_file_io(self, l, mode, p):
        try:
            w = open(p, mode)
            if mode == 'w':
                w.write(l)
                w.close()
            if mode == 'r':
                o = w.read()
                w.close()
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
        if self.scheme == 'jats':
            tr = self.create_output_jats(tr)
        elif self.scheme == 'bits':

            tr = self.create_output_bits(tr)

    def run(self):
        self.process_xml_file()


def main():
    xp = XMLProcess()
    xp.run()

if __name__ == '__main__':
    main()
