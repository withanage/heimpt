#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usage:
    xmlProcess.py  <input_file>  <path> [options]
    xmlProcess.py -h --help 
Options:
    -d, --debug   Enable debug output
    -s --sort-references
    -n --set-numbering=<elemennt types as comma seperated lists>
    -u --set-uuids=<element types as comma seperated list>
    -t --set-numbering-types=<numbering types e.g. roman , roman[1,2] >
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
            print
        return elem_array

    def set_tag_numbering(self, tree, tags):
        ''' automatic numbering of certain tags '''
        for tag in tags:
            sh = tree.findall('.//' + tag)
            sid = 1
            for i in sh:
                i.set('id', tag.replace('-', '') + str(sid))
                sid += 1
        return tree

    def set_uuids_for_back_matter(self, tr, tags):
        for s in tags:
            f = {}
            fns = tr.getroot().findall(
                ''.join(['.//xref/[@ref-type="', s, '"]']))
            for i in fns:
                rid = ''.join(['bibd', uuid.uuid4().get_hex()])
                f[i.attrib['rid']] = rid
                i.set('rid', rid)
            for m in f.keys():
                n = tr.getroot().find(''.join(['.//' + s + '/[@id="', m, '"]']))
                if n is not None:
                    if len(n) > 0:
                        n.set('id', f[m])
                    else:
                        self.debug.print_debug(self, self.gv.XML_ELEMENT_NOT_FOUND)
            return tr

    def transfrom(self, tr):
        set_numbering_tags = self.args.get('--set-numbering')
        set_uuids = self.args.get('--set-uuids')

        tr = self.set_tag_numbering(tr, set_numbering_tags.split(',')) if set_numbering_tags else tr
        tr = self.set_uuids_for_back_matter(tr, set_uuids.split(',')) if set_uuids else tr

        return tr

    def sort_references(self, tr, parent, tag_list):
        ''' sort all the references  '''
        elem = tr.find('./back/ref-list')
        data = []
        for e in elem:
            vl = []
            for tag in tag_list:
                vl.append(e.findtext(".//" + tag))
            vl.append(e)
            data.append(tuple(vl))
        data.sort()
        elem[:] = [item[-1] for item in data]

        return tr

    def process_xml_file(self):
        dr = self.args.get('<path>')
        f = self.args.get('<input_file>')

        tr = etree.parse(os.path.join(dr, f))
        root = tr.getroot()
        front = self.xml_elements_to_array(".//front",  root)
        body_secs = self.xml_elements_to_array(".//body/sec",  root)
        back_fns = self.xml_elements_to_array(".//back/fn-group/fn",  root)
        back_refs = self.xml_elements_to_array(".//back/ref-list/ref", root)
        back_fn_group = self.xml_elements_to_array(".//back/fn-group",  root)
        tr = self.transfrom(tr)
        # print etree.tostring(tr)
        self.gv.create_xml_file(tr, os.path.join(dr, os.path.basename(f)))

    def run(self):
        self.process_xml_file()


def main():
    xp = XMLProcess()
    xp.run()


if __name__ == '__main__':
    main()
