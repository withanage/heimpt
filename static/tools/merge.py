#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This  program is a utility file to merge a JATS/BITS XML  section into a BIS-XML files

The current functions are limited to JATS and BITS XML Scheme of the Library of Congress. However the methods defined in
this program can be used to modify any element tree.



Usage:
    merge.py  <input_file>  <path>  <scheme>  [options]

    merge.py -h --help

Options:
    -o --out-file=<output_file_name_without_escapes>
    -d --debug   Enable debug output
    -m --metadata=<file__name_schema.xml>
    -n --set-numbering-tags=<elemennt types as comma seperated lists>



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
from settingsconfiguration import Settings


try:
    from lxml import etree
    from lxml import objectify
except ImportError:
    print(PYTHON_IMPORT_FAILED_LXML_MODULE)
    sys.exit(1)


class Merge(Debuggable):
    """
     Standalone Processing object which merges current  JATS/BITS XML file in to the Body of a BITS-XML document.

    """

    def __init__(self):

        self.args = self.read_command_line()
        self.debug = Debug()
        self.settings = Settings(self.args)
        self.gv = GV(self.settings)
        self.uid = self.gv.uuid
        self.dr = self.args.get('<path>')
        self.f = self.args.get('<input_file>')
        self.scheme = self.args.get('<scheme>')
        self.set_numbering_tags = self.args.get('--set-numbering-tags')
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
        return docopt(__doc__, version='xmlMerge 0.0.1')

    def create_output_bits(self):
        """
        Create bits output file, generates a new file, if no file is found.
        Otherwise the current file is appended to the book body as a book-part.

        See Also
        --------
        create_book_part_bits, create_book_bits, do_file_io

        """
        fuf = os.path.join(self.dr, self.uid)
        pt = os.path.join(self.dr, os.path.basename(self.uid))

        trf = None
        if os.path.isfile(fuf):
            trf = etree.parse(fuf)
            bp = trf.find(".//book-body")
            book_part = self.create_book_part_bits()
            bp.append(book_part)
        else:
            trf = self.create_book_bits()
        trf = self.process(trf)

        self.do_file_io(etree.tostring(trf, pretty_print=True, xml_declaration=True,
                                       encoding='UTF-8', standalone='yes'), 'w', pt)

    def create_output_jats(self):
        """
        Create jats output file, generates a new file,

        See Also
        --------
        create_book_part_bits, create_book_bits, do_file_io

        """
        fuf = os.path.join(self.dr, self.uid)
        pt = os.path.join(self.dr, os.path.basename(self.uid))

        trf = None
        if os.path.isfile(fuf):
            trf = etree.parse(fuf)
            bpf = trf.find(".//body")
            f, bd, bk = self.get_xml_parts()
            if bd is not None:
                sec = list(bd)[0]
                bpf.append(sec)
            bkrf = trf.find(".//back/ref-list")
            print len(trf.findall(".//back/ref-list/ref"))
            print len(trf.findall('.//fn-group/fn'))
            for r in  bk.findall('.//ref-list/ref'):
                bkrf.append(r)

            bkff = trf.find(".//back/fn-group")
            for fn in bk.findall('.//fn-group/fn'):
                bkff.append(fn)


        else:
            trf = self.create_journal_jats()

        trf = self.process(trf)

        self.do_file_io(
            etree.tostring(trf, pretty_print=True, xml_declaration=True, encoding='UTF-8', standalone='yes'), 'w',
            pt)

    def process(self, tr):
        """
        Process  BITS-XML file and do all transformations into the elementtree

        Parameters
        ----------
        tr : elementtree
            element tree as input

        Returns
        -------
        tr : elementtree
            transformed element tree

        See Also
        --------
        globals.set_numbering_tags(), set_book_part_attributes()

        """
        tr = self.gv.set_numbering_tags(self.set_numbering_tags.split(
            ','), tr) if self.set_numbering_tags else tr

        self.set_book_part_attributes(tr)

        return tr

    def set_book_part_attributes(self, tr):
        """
        Add  specific attributes to book-part

        Parameters
        ----------
        tr : elementtree
            element tree as input


        Returns
        -------
        tr : elementtree
            transformed element tree


        """
        book_parts = tr.findall('.//book-part')
        for i, b in enumerate(book_parts):
            b.attrib['id'] = "ch_" + str(i)
            b.attrib['book-part-type'] = "chapter"
        return tr

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
        name, ext = os.path.splitext(os.path.basename(self.uid))
        file_name = [name, '.', metadata, '.', 'xml']
        p.append('metadata')
        p.append(''.join(file_name))

        pth = os.sep.join(p)
        self.debug.print_debug(self, u'merging headers' + str(pth))
        return pth

    def get_module_name(self):
        """
        Reads the name of the module for debugging and logging

        Returns
        -------
        name string
         Name of the Module
        """
        name = 'merge'
        return name

    def create_book_bits(self):
        """
        creates a  full BITS XML book and optionally adds metadata

        Returns
        -------
        book : elementtree
            Elementtree which complies to BITS XML Scheme.

        See Also
        ---------
        create_metadata_path, create_book_part_bits

        """
        nsmap = {'xlink': "http://www.w3.org/1999/xlink",
                 'mml': "http://www.w3.org/1998/Math/MathML",
                 "xml": "http://www.w3.org/XML/1998/namespace"}
        book = etree.Element(etree.QName('book'), nsmap=nsmap)
        book.attrib['dtd-version'] = "2.1"
        book.attrib[etree.QName('{http://www.w3.org/XML/1998/namespace}lang')] = "de"
        book.attrib['book-type'] = "proceedings"

        metadata = self.args.get('--metadata')

        if metadata:
            pth = self.create_metadata_path(metadata)
            self.debug.print_console(self, u'merging headers' + str(pth))
            if os.path.isfile(pth):
                bp = etree.parse(pth).find('.//book-meta')
                book.insert(0, bp)
            else:
                sys.exit(1)

        else:
            sys.exit('Metadata argument undefined')
        bd = etree.Element("book-body")
        bpbd = self.create_book_part_bits()
        bd.append(bpbd)
        book.append(bd)

        return book

    def create_journal_jats(self):
        """
        creates a  full JATS XML book and optionally adds metadata

        Returns
        -------
        book : elementtree
            Elementtree which complies to BITS XML Scheme.

        See Also
        ---------
        create_metadata_path, create_book_part_bits

        """

        nsmap = {'xlink': "http://www.w3.org/1999/xlink",
                 'mml': "http://www.w3.org/1998/Math/MathML",
                 "xml": "http://www.w3.org/XML/1998/namespace"}
        journal = etree.Element(etree.QName('article'), nsmap=nsmap)
        journal.attrib['dtd-version'] = "3.0"
        journal.attrib[etree.QName('{http://www.w3.org/XML/1998/namespace}lang')] = "de"

        metadata = self.args.get('--metadata')
        if metadata:
            pth = self.create_metadata_path(metadata)
            if os.path.isfile(pth):
                bpm = etree.parse(pth).find('.')
                if bpm is not None:
                    if bpm.getroottree().getroot().tag == 'front':
                        journal.insert(0, bpm)
                    else:
                        self.debug.print_debug(self, 'front metadata unspecified')
                        sys.exit(1)
        else:
            sys.exit('Metadata fails')
        f, bd, bk = self.get_xml_parts()
        journal.append(bd)
        #print etree.tostring(bk)
        journal = self.create_back(bk, journal)

        return journal

    def create_back(self, bk, journal):
        if len(bk) > 0:
            journal.append(bk)
        else:
            back = etree.Element(etree.QName('back'))
            back.append(etree.Element(etree.QName('fn-group')))
            back.append(etree.Element(etree.QName('ref-list')))
            journal.append(back)
        return journal

    def create_book_part_bits(self):
        """
        Reads a JATS XMl File and creates a book-part element tree according to BITS-XML.

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
        if bd is not None:
            bp.append(bd)
        if bk is not None:
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

    def run(self):
        """
         Runs the configuration on the processing object. Process  JATS-XML file and merges it into the full BITS-XML file

        See Also
        --------
        create_output_bits

        Warning
        -------
        function create_output_jats not yet used

        """

        self.gv.create_dirs_recursive(self.dr.split('/'))
        if self.scheme == 'bits':
            self.create_output_bits()

        elif self.scheme == 'jats':
            self.tr = self.create_output_jats()


def main():
    """
    Initializes a processing object from  a xml file and   and runs it.

    See Also
    --------
    run

    """
    xp = Merge()
    xp.run()

if __name__ == '__main__':
    main()
