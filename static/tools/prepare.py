#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""This  program is a utility file  which executes a set of specified functions on a element tree  of a xml file.

The current functions are limited to JATS and BITS XML Scheme of the Library of Congress. However the methods defined in
this program can be used to modify any element tree. Some of the  current available functions are sorting footnotes,
numbering elements of a certain type  or setting unique ids to a certain element types.

Usage:
    prepare.py  <input_file>  <path> [options]
Options:
    -d --debug   Enable debug output
    -f --sort-footnotes=<tag list as comma seperated lists>
    -h --help
    -m --metadata=<file__name_schema.xml>
    -n --set-numbering-tags=<elemennt types as comma seperated lists>
    -r --clean-references
    -s --sort-references=<tag list as comma seperated lists>
    -u --set-uuids=<element types as comma seperated list>
    -v --set-numbering-values=<numbering values, additionaly roman numbers e.g.xref,ref-type,fn,{1:2} >

All the  are done  in the global element tree for performance reasons.


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


class Prepare(Debuggable):
    """
    Standalone Processing object to combine, clean and modify a JATS XML file and optionally inject BITS Metadata headers.

    Features
    --------
    add Id numbering for any tag type, clean comments, remove unused references,
    set numbering, add unique ids to certain tag types, sort references

    """

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.settings = Settings(self.args)
        self.gv = GV(self.settings)
        Debuggable.__init__(self, 'Main')
        if self.args.get('--debug'):
            self.debug.enable_debug()
        self.dr = self.args.get('<path>')
        self.f = self.args.get('<input_file>')
        self.tr = etree.parse(os.path.join(self.dr, self.f))

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

    def remove_references(self):
        """ removes  references, which are not linked.

         Parameters
         -----------
         tag : str
            name of the XML tag

         Returns
         -------
         tr : elementtree

         See Also
         --------
         remove_element, remove_tags

        """
        r = self.tr.getroot()

        for e in r.findall('.//back/ref-list/ref'):
            if e.attrib.get('id'):
                if r.find(".//xref[@ref-type='bibr'][@rid='" + e.attrib.get('id') + "']") is None:
                    self.remove_element(e)
            else:
                self.remove_element(e)
        for e in r.findall(".//xref[@ref-type='bibr']"):
            if r.find(".//back/ref-list/ref[@id='" + e.attrib.get('rid') + "']") is None:
                if e.getparent() is not None:
                    for c in e.getparent().getiterator():
                        if c.tag == 'xref' and c.attrib.get('ref-type') == 'bibr':
                            self.remove_tags(c)
        return self.tr

    def remove_tags(self, e):
        """
        Takes an etree element and replaces it with its own text

        Parameters
        ----------
        e : element
            Element to be replaced

        """
        if e.getparent() is not None:
            previous = e.getprevious()
            if previous is not None:
                if previous.tail:
                    if e.text:
                        previous.tail = previous.tail + e.text
                    if e.tail:
                        previous.tail = previous.tail + e.tail
                    e.getparent().remove(e)

    def remove_element(self, e):
        """
        Remove any element only if it has a parent

        Parameters
        ----------
        e : element
            Element to be replaced

        """
        if e.getparent() is not None:
            e.getparent().remove(e)

    def set_uuids_for_back_matter(self, tags):
        """
        Add unique id tags to  any of the sub-elements of the back matter

        Parameters
        ----------
        tags: list
         list of elements

        Returns
        -------
        tr : elementtree

        """
        for s in tags:
            f = {}
            ref_type = 'bibr' if s == 'ref' else s
            fns = self.tr.getroot().findall(
                ''.join(['.//xref/[@ref-type="', ref_type, '"]']))
            for i in fns:
                rid = ''.join(['bibd', uuid.uuid4().get_hex()])
                f[i.attrib['rid']] = rid
                i.set('rid', rid)
            for m in f.keys():
                n = self.tr.getroot().find(
                    ''.join(['.//' + s + '/[@id="', m, '"]']))
                if n is not None:
                    n.set('id', f[m]) if len(n) > 0 else ''
        return self.tr

    def set_numbering_values(
            self,
            tag,
            attr,
            value,
            count,
            range_list):
        """
        Adds numerical values to  a  tag  in arguments list

        Parameters
        ---------
        tag: str
            xml tag name
        attr: str
            attribute name
        value :str
            value name
        count : int
            current sequence number
        range_list : list
           lower and upper level for the  numbering

        See Also
        --------
        set_roman_numbers

        """
        searchTag = './/' + tag + '[@' + attr + '="' + value + '"]'
        elems = self.tr.getroot().findall(searchTag)
        range_count = 1
        for elem in elems:
            elem.text, range_count = self.set_roman_numbers(
                count, range_count, range_list)
            count += 1

        return self.tr, count

    def convert_int_to_roman(self, i):
        """
        Converts an integer number into a roman number

        Parameters
        ---------
        i : int
            integer number

        Returns
        -------
        result : str
            Roman number

        """
        result = []
        for integer, numeral in self.gv.numeral_map:
            count = i // integer
            result.append(numeral * count)
            i -= integer * count
        return ''.join(result)

    def set_roman_numbers(self, count, r_count, range_list):
        """
        Converts a given set of elements defined by range_array into roman numbers

        Parameters
        ---------
        count :int
        r_count : int
        range_list : list
            lower and upper level for the  numbering

        Returns
        -------
        val : str
        r_count: int

        See Also
        --------
        convert_int_to_roman

        """

        val = str(count)
        if int(range_list[0]) <= count <= int(range_list[1]):
            val = self.convert_int_to_roman(r_count).lower()
            r_count += 1
        else:
            val = str(count - r_count + 1)
        return val, r_count

    def merge_metadata(self, metadata):
        """
        reads a metadata file path and  merge its content into the metadata section

        Parameters
        ----------
        metadata : str
             suffix  of the metadata files

        Returns
        -------
        tr : elementTree
            Element tree of the  current file

        See Also
        -------
        create_metadata_path

        """
        r = self.tr.getroot()

        pth = self.create_metadata_path(metadata)


        if os.path.isfile(pth):
            fr = r.find('.//front')
            if len(fr):
                bg = r.find('.//body').getparent()
                fr.getparent().remove(fr)
                bpm = etree.parse(pth).find('.//book-part-meta')
                if bpm is None:
                    bpm = etree.parse(pth).find('.')
                    if bpm is not None:
                        if bpm.getroottree().getroot().tag == 'front':
                            bg.insert(0, bpm)
                        else:
                            self.debug.print_debug(self, 'front or bookpart metadata unspecified')
                            sys.exit(1)
                else:
                    bg.insert(0, bpm)
            else:
                self.debug.print_debug(self, 'front metadata unspecified')
        else:
            self.debug.print_debug(self, pth +
                                   self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST)
            sys.exit(1)
        return self.tr

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
        f = os.path.basename(self.f)
        name, ext = os.path.splitext(f)
        file_name = [name, '.', metadata, ext]
        p.append('metadata')
        p.append(''.join(file_name))
        pth = os.sep.join(p)
        return pth

    def sort_by_tags(self, tag_list, elem):
        """
        Sorts  a   list  of elements alphabetically

        Parameters
        ----------
        tag_list : list
            A list of tag types
        elem : Element
            Element to be modified

        """
        data = []
        for e in elem:
            vl = []
            for tag in tag_list:
                vl.append(e.findtext(".//" + tag))
            vl.append(e)
            data.append(tuple(vl))

        data.sort()
        elem[:] = [item[-1] for item in data]

    def sort_references(self, tag_list):
        """
        Sort references based on the  sub-elements list

        Parameters
        ----------
        tag_list : list
            A list of tag types


        Returns
        -------
        tr : elementTree
            Element tree of the  current file

        See Also
        --------
        sort_by_tags
        """
        elem = self.tr.find('./back/ref-list')
        self.sort_by_tags(tag_list, elem)

        return self.tr

    def sort_footnotes(self, tag_list):
        """
        Sort footnotes based on the  sub-elements list

        Parameters
        ----------
        tag_list : list
            A list of tag types


        Returns
        -------
        tr : elementTree
            Element tree of the  current file

        See Also
        --------
        sort_by_tags
        """
        elem = self.tr.find('./back/fn-group')
        self.sort_by_tags(tag_list, elem)

        return self.tr

    def process(self):
        """
        Process  JATS-XML file and do all transformations into the elementtree

        See Also
        --------
        merge_metadata, set_numbering_tags,set_uuids_for_back_matter,sort_footnotes,sort_references,set_numbering_values

        """

        clean_references = self.args.get('--clean-references')

        set_numbering_tags = self.args.get('--set-numbering-tags')
        set_unique_ids = self.args.get('--set-uuids')
        sort_footnotes = self.args.get('--sort-footnotes')
        sort_references = self.args.get('--sort-references')
        set_numbering_values = self.args.get('--set-numbering-values')

        metadata = self.args.get('--metadata')
        self.tr = self.merge_metadata(metadata) if metadata else self.tr

        self.tr = self.remove_references() if clean_references else self.tr
        self.tr = self.gv.set_numbering_tags(set_numbering_tags.split(
            ','), self.tr) if set_numbering_tags else self.tr
        self.tr = self.set_uuids_for_back_matter(
            set_unique_ids.split(',')) if set_unique_ids else self.tr
        self.tr = self.sort_footnotes(
            sort_footnotes.split(',')) if sort_footnotes else self.tr
        self.tr = self.sort_references(
            sort_references.split(',')) if sort_references else self.tr

        for s in set_numbering_values.split(';'):
            vals = s.split(',')

            count = 1
            range_count = [0, 0]

            if len(vals) > 3:
                r = vals[3].lstrip('{').rstrip('}').split(':')
                range_count = [int(r[0]), int(r[1])]
            self.tr, count = self.set_numbering_values(
                vals[0], vals[1], vals[2], count, range_count)

        self.gv.create_dirs_recursive(self.dr.split('/'))
        self.create_xml_file(
            os.path.join(
                self.dr, os.path.basename(
                    self.f)))

    def get_module_name(self):
        """
        Reads the name of the module for debugging and logging

        Returns
        -------
        name string
         Name of the Module
        """
        name = 'prepare'
        return name

    def create_xml_file(self, pth):
        """
        Write the current elementTree into the file path

        Parameters
        ----------
        pth : str
            Correct path of the metadata file in the folder structure

        Raises
        ------
        IOError
            I/O operation fails

        Notes
        -----
        Default configuration writes a normalized XML file with XML scheme

        """

        try:

            self.tr.write(
                pth,
                pretty_print=False,
                xml_declaration=True
            )
            print
        except IOError as e:
            print e
            self.debug.print_debug(self, self.XML_FILE_NOT_CREATED)

    def run(self):
        """
        Runs the configuration on the processing object

        See Also
        --------
        process


        """
        self.process()


def main():
    """
    Initializes a processing object from  a xml file and   and runs it.

    See Also
    --------
    run

    """
    xp = Prepare()
    xp.run()


if __name__ == '__main__':
    main()
