# coding: utf-8
#!/usr/bin/env python
# The MIT License

# Copyright 08-May-2016, 14:51:07
#
# Author    : Dulip Withanage , University of Heidelberg
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


import copy
import io
import json
import logging
import os
from sets import Set
import sys
import time
import uuid
import zipfile
try:
    from lxml import etree
    from lxml import objectify
except ImportError:
    print("Failed to import ElementTree, plase install")


LOG_FILE = 'jatsPostProcess.log'
logging.basicConfig(filename=LOG_FILE, level=logging.DEBUG)


class PostProcess:
    '''
     command line tool to clean, modify, delete, merge jats files
    '''

    def __init__(self, cf):
        try:
            with open(cf) as json_data_file:
                self.config = json.load(json_data_file)
        except:
            print 'Please define', cf
            sys.exit(1)

        self.JATS_XML_HEADER = '<!DOCTYPE article PUBLIC "-//NLM//DTD Journal Publishing DTD v3.0 20080202//EN" "http://dtd.nlm.nih.gov/publishing/3.0/journalpublishing3.dtd"><article xmlns:xlink="http://www.w3.org/1999/xlink">'

    def apply_transformations(self, tr, context):
        ''' main method to apply transformations'''
        tr = self.remove_not_used_in_back(tr, "ref-list/ref")
        tr = self.remove_not_used_in_back(tr, "fn-group/fn")
        tr = self.set_enumeration(tr, "xref", "ref-type", "fn")
        tr = self.remove_name_duplicates_speech(tr)
        tr = self.set_numbering(tr, ['speech', 'disp-quote'])
        tr = self.get_unreferenced_footnotes(tr)
        tr = self.set_uuids(tr, 'fn')
        tr = self.merge_repeating_neighbours(tr, "disp-quote")              
        if "references" in self.config["createFull"][context].keys():
            if "duplicates" in self.config[
                    "createFull"][context]["references"].keys():
                for i in self.config["createFull"][
                        context]["references"]["duplicates"]:
                    tr = self.remove_duplicate_refs(tr, i)
        return tr

    def contains(self, a, v):
        ''' help method to compare references '''
        (c1, c2, c3, c4) = v
        if c1 and c2:
            for (v1, v2, v3, v4) in a:
                if v1 == c1 and v2 == c2 and v3 == c3 and v4 == c4:
                    return True
        return False

   
        
    def create_files(self, context):
        ''' main method : creates zip, merges and transforms xml files '''
        cfb = self.config['createFull'][context]
        self.create_zip(cfb["dir"], cfb["files"])

        fp = os.path.join(cfb["dir"], cfb["fullfile"])
        
        header_text, back_fns, body_secs, back_refs  = self.merge_files(cfb["dir"], cfb["files"], context)
        body_text = ''.join(body_secs)
        fns = ''.join(back_fns)
        refs = ''.join(back_refs)
        out = "%s%s<body>%s</body><back><fn-group>%s</fn-group><ref-list>%s</ref-list></back></article>" % (
            self.JATS_XML_HEADER, header_text, body_text, fns, refs)

        f = open(fp, 'w')
        f.write(out)
        f.close()
        if  "footnotes_file" in cfb.keys():
          fpfn = os.path.join(cfb["dir"], cfb["footnotes_file"])
          fns_p=[]
          for i in back_fns:
            for j in etree.fromstring(i).getchildren():
              fns_p.append(etree.tostring(j))
            
          out_fn =  out = "%s%s<body><sec>%s</sec></body><back></back></article>" % (self.JATS_XML_HEADER, header_text,  ''.join(fns_p))
          f = open(fpfn, 'w')
          f.write(out_fn)
          f.close()
           
           
        tr = self.apply_transformations(self.get_etree(fp), context)
        self.create_output(tr, fp)
        logging.info('outout written' + cfb["fullfile"])

        return None

    def create_output(self, tree, file):
        ''' write element tree to file '''
        try:
            tree.write(
                file,
                pretty_print=True,
                xml_declaration=True,
                encoding='UTF-8')

        except:
            logging.info(self.config['errors']['FILE_NOT_WRITTEN'])

    def create_refs_csv(self, dir, infile, outfile, types):
        ''' write a csv file from the references '''
        file = os.path.join(dir, infile)
        tree = self.get_etree(file)
        elem = tree.find('./back/ref-list')
        out = ''
        for e in elem:
            for t in types:
                if e.find('.//' + t) is not None:
                    out += e.find('.//' + t).text + ','
                out += '\n'
        tf = open(outfile, "w")
        tf.write(unicode(out).encode("utf-8"))
        tf.close()

    def create_zip(self, dir, files):
        ''' create a zip file from a set of files and a directory path '''
        try:
            z = zipfile.ZipFile(os.path.join(dir, ''.join(
                [self.config["zip"]["name-prefix"], str(time.time()), '.zip'])), "w")
            for f in files:
                z.write(os.path.join(dir, f),
                        compress_type=zipfile.ZIP_DEFLATED)
        except:
            pass

    def get_etree(self, infile):
        ''' reads a file and get the element tree '''
        try:
            tree = etree.parse(infile)
        except:
            print self.config['errors']['FILE_NOT_FOUND']
            sys.exit(2)
        return tree

    def get_footnotes_back(self, tree):
        '''returns footnotes in back '''
        back_fns = Set()
        for back in tree.getroot().findall(".//back/fn-group"):
            for fn in back.findall(".fn"):
                if fn.keys():
                    back_fns.add(fn.attrib['id'])
        return back_fns

    def get_footnotes_body(self, tree):
        '''returns footnotes in body '''
        body_fns = Set()
        for body in tree.getroot().findall(".//body"):
            for fn in body.findall(".//xref[@ref-type='fn']"):
                if fn.keys():
                    body_fns.add(fn.attrib['rid'])
        return body_fns

    def get_ref_ids_back(self, tree):
        '''returns references in back '''
        back_refs = Set()
        for back in tree.getroot().findall(".//back/ref-list"):
            for ref in back.findall(".ref"):
                if ref.keys():
                    back_refs.add(ref.attrib['id'])
        return back_refs

    def get_ref_ids_body(self, tree):
        '''returns references in body '''
        body_refs = Set()
        for body in tree.getroot().findall(".//body"):
            for ref in body.findall(".//xref[@ref-type='bibr']"):
                if ref.keys():
                    body_refs.add(ref.attrib['rid'])
        return body_refs

    def get_refs_mixed_back(self, tree):
        '''returns mixed citations in back '''
        back_refs = Set()
        for back in tree.getroot().findall(".//back/ref-list/ref"):
            for ref in back.findall(".//mixed-citation"):
                loggin.info(
                    "Mixed reference found", etree.tostring(
                        back, pretty_print=True))
        return back_refs

    def get_unreferenced_footnotes(self, tr):
        ''' returns a list of footnotes, which are not in body '''
        body_fns = self.get_footnotes_body(tr)
        back_fns = self.get_footnotes_back(tr)
        for i in back_fns:
            if i in body_fns:
                pass
            else:
                logging.info("Footnote " + i + " is not used")

        return tr

    
    def merge_repeating_neighbours(self, tr, etype):
        root =tr.getroot()
        for i in root.findall('.//'+etype):
            if i.tag==etype:
                if i.getparent().getprevious() is not None:
                  if i.getparent().getprevious().getchildren():
                    if  i.getparent().getprevious().getchildren()[0].tag==etype:
                      i.getparent().getprevious().getchildren()[0].append(copy.deepcopy(i.getchildren()[0]))
                      i.getparent().getparent().remove(i.getparent())
        return tr
    
    def merge_files(self, dir, files, context):
        '''  merge  a set of xml files in a directory'''
        back_fns, body_secs, back_refs = [], [], []
        header = False
        header_text=''

        for f in files:
            logging.info("Parsing file " + f)
            tr = etree.parse(os.path.join(dir, f))
            tr = self.apply_transformations(tr, context)
            self.create_output(tr, os.path.join(dir, f))
            root = tr.getroot()
            if not header:
                for header_text in root.findall(".//front"):
                    header_text = ''.join(etree.tostring(
                        header_text, pretty_print=False))
                    header = True
            for sec in root.findall(".//body/sec"):
                body_secs.append(etree.tostring(sec, pretty_print=False))
            for back in root.findall(".//back/fn-group/fn"):
                back_fns.append(etree.tostring(back, pretty_print=False))
            for ref in root.findall(".//back/ref-list/ref"):
                back_refs.append(etree.tostring(ref, pretty_print=False))

        return  header_text, back_fns, body_secs, back_refs 

    def remove_all_elements_of_type(self, tree, names):
        ''' removes all the elements of a certain type in a element tree '''
        for name in names:
            for elem in tree.getroot().findall('.//' + name):
                elem.getparent().remove(elem)
        return tree

    def remove_comments(self, tree):
        ''' removes all the comments  in a element tree '''
        comments = tree.xpath('//comment()')
        for c in comments:
            p = c.getparent()
            p.remove(c)
        return tree

    def remove_duplicate_refs(self, tr, tag_list):
        ''' removes duplicate references'''
        ref_list = tr.find('./back/ref-list')
        data = []
        drf = {}
        for e in ref_list:
            vl = []
            for tag in tag_list:
                vl.append(e.findtext(".//" + tag))
            vl.append(e)
            data.append(tuple(vl))

        data.sort()
        ref_list[:] = [item[-1] for item in data]
        prev = ('', '', '', '')
        lat_id = 0

        for i, v in enumerate(data):
            if v[0] is not None and v[1] is not None and v[2] is not None:
                if prev[0] == v[0] and prev[1] == v[1] and prev[2] == v[2]:
                    drf[last_id] = v[len(v) - 1].attrib['id']
                else:
                    prev = v
                    last_id = v[len(v) - 1].attrib['id']
        # replace refs
        i = 0
        for key in drf:
            for xref in tr.findall(
                    './/xref[@rid="' + drf[key] + '"]'):
                xref.set('rid', key)
            for ref in tr.findall('.//ref[@id="' + drf[key] + '"]'):
                i += 1
                ref.getparent().remove(ref)
        return tr

    def remove_name_duplicates_speech(self, tr):
        ''' removes name duplication  in  speech tag '''
        elems = tr.getroot().findall('.//speech/p')
        for elem in elems:
            for l in list(elem):
                if l is not None:
                    elem.text = ""
        return tr

    def remove_not_used_in_back(self, tr, tag):
        ''' removes  footnotes, references, which are not linked. '''
        body_refs = self.get_ref_ids_body(tr)
        back_refs = self.get_ref_ids_back(tr)

        for i in back_refs:
            if i in body_refs:
                pass
            else:
                elems = tr.getroot().findall(
                    ''.join(['.//back/', tag, '/[@id="', str(i), '"]']))
                for e in elems:
                    if e.getparent() is not None:
                        e.getparent().remove(e)
                        logging.info(tag + etr.tostring(e) + " removed")
        return tr

    def remove_table_references(self, tree, name, attr, value):
        searchTag = './/' + name + '[@' + attr + '="' + value + '"]'
        try:
            with open(self.TABLESTYLEFILE, 'r') as file:
                xslt = file.read()
        except:
            logging.error(self.config['errors']['FILE_NOT_FOUND'])
            sys.exit(2)
        xslt_doc = etree.parse(io.BytesIO(xslt))
        transform = etree.XSLT(xslt_doc)
        return transform(tree)

    def set_enumeration(self, tr, name, attr, value):
        ''' set the count id for an attribute in a tag type '''
        searchTag = './/' + name + '[@' + attr + '="' + value + '"]'
        elems = tr.getroot().findall(searchTag)
        count = 1
        for elem in elems:
            elem.text = str(count)
            count += 1
        return tr

    def set_numbering(self, tree, tags):
        ''' automatic numbering of certain tags '''
        for tag in tags:
            sh = tree.findall('.//' + tag)
            sid = 1
            for i in sh:
                i.set('id', tag.replace('-', '') + str(sid))
                sid += 1
        return tree

    def set_uuids(self, tr, str):
        ''' removes name confilcits for references or footnotes'''
        f = {}
        fns = tr.getroot().findall(
            ''.join(['.//xref/[@ref-type="', str, '"]']))
        for i in fns:
            rid = ''.join(['bibd', uuid.uuid4().get_hex()])
            f[i.attrib['rid']] = rid
            i.set('rid', rid)
        for m in f.keys():
            n = tr.getroot().find(''.join(['.//fn/[@id="', m, '"]']))
            if n is not None:
              if len(n) > 0:
                  n.set('id', f[m])
              else:
                  logging.error('Element not found \t' + m)
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


def main():
    p = PostProcess('postProcessConfig.json')
    context = "kemp"
    p.create_files(context)
    with open(LOG_FILE) as f:
        print f.read()
    os.remove(LOG_FILE)

if __name__ == "__main__":
    main()
