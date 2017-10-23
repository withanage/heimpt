# coding: utf-8
#!/usr/bin/env python

# Copyright 23-Oct-2017, 14:51:00
#
# Author    : Dulip Withanage , University of Heidelberg


import sys
import re
try:
    from lxml import etree
    from lxml import objectify
except ImportError:
    print("Failed to import ElementTree, please install")

numeral_map = tuple(zip(
    (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1),
    ('M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I')
))
ns_tei ='{http://www.tei-c.org/ns/1.0}'
import lxml.html
class TEIProcess:
    '''
     command line tool to clean, modify, delete, merge jats files
    '''

    def __init__(self, cf):
        try:
            self.tr = etree.parse(cf)
        except:
            print('{} {}'.format('Please define', cf))
            sys.exit(1)

        self.TEI_XML_HEADER = '<TEI xmlns="http://www.tei-c.org/ns/1.0">'



    def print_definitions(self):

        root = self.tr.getroot()
        st= etree.tostring(root, pretty_print=False)
        #print (st)
        f = (re.findall(r'(\w+)(\s+)(\w+)(\s+)(\()(<hi(\s+)rend="italic">)(\S+)(</hi>)',str(st)))
        #rint (f)
        for found in f :
            print (found[0],found[2],' = ', lxml.html.fromstring(found[7]).text.encode('utf-8').decode('utf-8'))


        #print re.findall(r'(\w+)',st)
        #items = self.tr.findall('.//{}{}'.format(ns_tei,'item'))



    def apply_transformations(self):
        ''' main method to apply transformations'''

        self.tr = self.print_definitions()

    def create_files(self,f_name):
        f = open(f_name, 'w')
        out = etree.tostring(self.tr, pretty_print=False)
        f.write(out)




def main():
    if len(sys.argv) >= 2:
        p = TEIProcess(sys.argv[1])
        p.print_definitions()
        #p.create_files('output.xml')


    else:
        print(' file not defined, please define the path')

if __name__ == "__main__":
    main()
