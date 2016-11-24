#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This  program is a utility file to merge a JATS/BITS XML  section into a BIS-XML files

The current functions are limited to JATS and BITS XML Scheme of the Library of Congress. However the methods defined in
this program can be used to modify any element tree.



Usage:
    xmlMerge.py  <input_file>  <path>  <scheme> <output_file>  [options]

    xmlMerge.py -h --help

Options:
    -d, --debug   Enable debug output
    -m --metadata=<file__name_schema.xml>


References
----------
* Web : https://github.com/withanage/mpt
* Repository and issue-tracker: https://github.com/withanage/mpt/issues
* Licensed under terms of GPL 3  license (LICENSE.md)


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


class XMLMerge(Debuggable):
    """
     Standalone Processing object which merges current  JATS/BITS XML file in to the Body of a BITS-XML document.

    """

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
        self.uid = '4e4dd8cf-26bf-4893-b037-1fd3bf08f112'
        self.dr = self.args.get('<path>')
        self.f = self.args.get('<input_file>')
        self.scheme = self.args.get('<scheme>')
        self.o = self.args.get('<output_file>')
        self.tr = etree.parse(os.path.join(self.dr, self.f))
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()

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
        return docopt(__doc__, version='xml 0.1')

    def create_output_bits(self):
        """
        Create bits output file, generates a new file, if no file is found.
        Otherwise the current file is appended to the book body as a book-part.

        See Also
        --------
        create_book_part_bits, create_book_bits, do_file_io

        """
        fuf = os.path.join(self.dr, self.o)
        pt = os.path.join(self.dr, os.path.basename(self.o))
        if os.path.isfile(fuf):
            trf = etree.parse(fuf)
            bp = trf.find(".//book-body")
            book_part = self.create_book_part_bits()
            bp.append(book_part)
            self.do_file_io(etree.tostring(trf, pretty_print=True), 'w', pt)

        else:
            book = self.create_book_bits()
            self.do_file_io(etree.tostring(book, pretty_print=True), 'w', pt)

    def create_metadata_path(self, metadata):
        """
        creates the correct folder path for the metadata file. Metadata files should be in a folder : metadata

        Parameters
        ----------
        metadata : str
            Suffix of the metadata  files

        Returns
        -------
        pth : str
            Correct path of the metadata file in the folder structure

        Notes
        -----
        We assume that  metadata files are stored in a sub-folder named metadata
        """
        p = os.path.dirname(self.f).split(os.sep)
        del p[-4:]
        name, ext = os.path.splitext(os.path.basename(self.o))
        file_name = [name, '.', metadata, ext]
        p.append('metadata')
        p.append(''.join(file_name))
        pth = os.sep.join(p)
        return pth

    def create_book_bits(self):
        """
        creates a  full BITS XML book and optionally adds metadata

        Returns
        -------
        book : elementtree
            Elementtree which complies to BITS XML Schheme.

        See Also
        ---------
        create_metadata_path, create_book_part_bits

        """
        book = etree.Element("book")

        metadata = self.args.get('--metadata')
        if metadata:
            pth = self.create_metadata_path(metadata)
            if os.path.isfile(pth):
                bp = etree.parse(pth).find('.//book-meta')
                book.insert(0, bp)

        bd = etree.Element("book-body")
        bpbd = self.create_book_part_bits()
        bd.append(bpbd)
        book.append(bd)

        return book

    def create_book_part_bits(self):
        """
        Reads a JATS XNl File and creates a book-part element tree according to BITS-XML.

        Returns
        -------
        bp : elementtree
            Book part elementTree
        """

        f, bd, bk = self.get_xml_parts()

        bp = etree.Element("book-part")
        if f is not None:
            if len(f):
                bp.append(f)
        bp.append(bd)
        bp.append(bk)
        return bp

    def get_xml_parts(self):
        """
        Returns  the front-matter , body and back-matter of a JATS XML file in the above order

        Returns
        -------
        f : elementtree
            Front-matter of JATS elementTree
        bd : elementtree
            Body of JATS elementTree
        bk : elementtree
            Back-matter of JATS elementTree

        """
        r = self.tr.getroot()
        f = r.find(".//front")
        if f is None:
            f = r.find(".//book-part-meta")
        bd = r.find(".//body")
        bk = r.find(".//back")
        return f, bd, bk

    def do_file_io(self, s, mode, pth):
        """
        Executes read or write operations on a path

        Parameters
        ----------
        s: str
            Content to be written or None for read
        mode: str
            w for write , r for r
        pth : str
            Path to the file to be read or written

        Raises
        ------
        IOError
            I/O operation fails

        """
        try:
            w = open(pth, mode)
            if mode == 'w':
                w.write(s)
                w.close()
            if mode == 'r':
                o = w.read()
                w.close()
        except IOError as i:
            self.debug.print_debug(self, i)
            print(i)
            sys.exit(1)

    def process_xml_file(self):
        """
        Process  JATS-XML file and merges it into the full BITS-XML file

        See Also
        --------
        create_output_bits

        Warning
        -------
        function create_output_jats not yet used

        """

        self.gv.create_dirs_recursive(self.dr.split('/'))
        if self.scheme == 'bits':
            self.tr = self.create_output_bits()
        elif self.scheme == 'jats':
            self.tr = self.create_output_jats(self.tr)

    def run(self):
        """
        Runs the configuration on the processing object

        See Also
        --------
        process_xml_file

        """
        self.process_xml_file()


def main():
    """
    Initializes a processing object from  a xml file and   and runs it.

    See Also
    --------
    run

    """
    xp = XMLMerge()
    xp.run()

if __name__ == '__main__':
    main()
