#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This  program is a utility file  which executes a set of specified functions on a element tree  of a xml file.

The current functions are limited to JATS and BITS XML Scheme of the Library of Congress. However the methods defined in
this program can be used to modify any element tree. Some of the  current avaliable functions are sorting footnotes,
numbering elements of a certain type  or setting unique ids to a certain element type.


Usage:
    xmlProcess.py  <input_file>  <path> [options]

Options:
    -d, --debug   Enable debug output
    -f --sort-footnotes=<tag list as comma seperated lists>
    -h --help
    -m --metadata=<file__name_schema.xml>
    -n --set-numbering=<elemennt types as comma seperated lists>
    -r  --remove-references-unused
    -s --sort-references=<tag list as comma seperated lists>
    -t --set-numbering-types=<numbering types e.g. roman , roman[1,2] >
    -u --set-uuids=<element types as comma seperated list>

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
    Standalone module to combine, clean and modify a JATS XML file and optionally inject BITS Metadata headers.

    Features:        Add Id numbering for any tag type
        Clean comments
        Remove unused references
        Set numbering
        Add unique ids to certain tag types
        Sort references

    """

    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        self.gv = GV()
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

    def set_tag_numbering(self, tags):
         """
         Automatic numbering of the list of elements

         Parameters
         ----------
         tags: list
          list of elements

         """
         for tag in tags:
            sh = self.tr.findall('.//' + tag)
            sid = 1
            for i in sh:
                i.set('id', tag.replace('-', '') + str(sid))
                sid += 1
         return self.tr


    def set_uuids_for_back_matter(self, tags):
        """
        Add unique id tags to  any of the sub-elements of the back matter

        Parameters
        ----------
        tags: list
         list of elements


        """
        for s in tags:
            f = {}
            fns = self.tr.getroot().findall(
                ''.join(['.//xref/[@ref-type="', s, '"]']))
            for i in fns:
                rid = ''.join(['bibd', uuid.uuid4().get_hex()])
                f[i.attrib['rid']] = rid
                i.set('rid', rid)
            for m in f.keys():
                n = self.tr.getroot().find(
                    ''.join(['.//' + s + '/[@id="', m, '"]']))
                if n is not None:
                    if len(n) > 0:
                        n.set('id', f[m])
                    else:
                        self.debug.print_debug(
                            self, self.gv.XML_ELEMENT_NOT_FOUND)
        return self.tr
    def set_numbering(
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


        """

        val = str(count)
        if int(range_list[0]) <= count <= int(range_list[1]):
            val = self.convert_int_to_roman(r_count).lower()
            r_count += 1
        else:
            val = str(count - r_count + 1)
        return val, r_count

    def transform(self):
        """
        Function applies transformation into the elementtree

        Returns
        -------
        tr : elementTree
            Element tree of the  current file


        """
        set_numbering_tags = self.args.get('--set-numbering')
        set_uuids = self.args.get('--set-uuids')
        sort_footnotes = self.args.get('--sort-footnotes')
        sort_references = self.args.get('--sort-references')

        metadata = self.args.get('--metadata')
        self.tr = self.merge_metadata(metadata) if metadata else self.tr

        self.tr = self.set_tag_numbering(set_numbering_tags.split(
            ',')) if set_numbering_tags else self.tr
        self.tr = self.set_uuids_for_back_matter(
            set_uuids.split(',')) if set_uuids else self.tr
        self.tr = self.sort_footnotes(
            sort_footnotes.split(',')) if sort_footnotes else self.tr
        self.tr = self.sort_references(
            sort_references.split(',')) if sort_references else self.tr

        return self.tr

    def merge_metadata(self, metadata):
        """
        Reads a metadata file path and  merge its content into the metadata section

        Parameters
        ----------
        metadata : str
             suffix  of the metadata files

        Returns
        -------
        tr : elementTree
            Element tree of the  current file


        """
        r = self.tr.getroot()

        pth = self.create_metadata_path(metadata)

        if os.path.isfile(pth):
            fr = r.find('.//front')
            fr.getparent().remove(fr)
            bpm = etree.parse(pth).find('.//book-part-meta')
            bg = r.find('.//body').getparent()
            bg.insert(0, bpm)

        else:
            self.debug.print_debug(self, pth +
                                   self.gv.PROJECT_INPUT_FILE_DOES_NOT_EXIST)

        return self.tr

    def create_metadata_path(self, metadata):
        """
        creates the correct folder path for the metadata file. Metadata files should be in a folder : metadata
        :param metadata:
        :return:
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
        :param tag_list:
        :param elem:
        :return:
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
        sort references
        :param self.tr:
        :param tag_list:
        :return:
        """
        elem = self.tr.find('./back/ref-list')
        self.sort_by_tags(tag_list, elem)

        return self.tr

    def sort_footnotes(self, tag_list):
        """
        sort footnotes
        :param tr:
        :param tag_list:
        :return:
        """
        elem = self.tr.find('./back/fn-group')
        self.sort_by_tags(tag_list, elem)

        return self.tr

    def process_xml_file(self):
        """
        process  xml  file and do all transformations
        :return:
        """

        #tr = etree.parse(os.path.join(self.dr, self.f))

        self.tr = self.transform()
        count = 1
        range_count = [1, 2]
        self.tr, count = self.set_numbering(
            "xref", "ref-type", "fn", count, range_count)
        self.gv.create_dirs_recursive(self.dr.split('/'))
        self.gv.create_xml_file(
            self.tr, os.path.join(
                self.dr, os.path.basename(
                    self.f)))

    def run(self):
        """
        main function  which call xml processing
        :return:
        """
        self.process_xml_file()


def main():
    """
    main method
    :return:
    """
    xp = XMLProcess()
    xp.run()


if __name__ == '__main__':
    main()
