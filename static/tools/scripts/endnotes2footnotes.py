#!/usr/bin/python

import sys, copy
from xml.etree import ElementTree

f = sys.argv[1]
tree = ElementTree.parse(f)
root = tree.getroot()

chapters = []

for child in root:
	if child.tag == 'body':
		current_body = child
	if child.tag == 'back' and current_body is not None:
		chapters.append((current_body, child))
		current_body = None

for body, back in chapters:
	refs = {}
	rlist = back.find('ref-list')
	for ref in rlist:
		rid = ref.get('id')
		ec, ac, content = None, None, None
		ec = ref.find('element-citation')
		if ec is not None:
			at = ec.find('article-title')
		if at is not None:
			content = at.find('div')
			refs[rid] = content

	for sec in body.iter('sec'):
		for p in sec.iter('p'):
			for ref in p.findall('xref'):
				if ref.get('ref-type'):
					rid = ref.get('rid')
					if rid:
						# delete content
						ref.clear()
						# make footnote tag
						ref.tag = 'footnote'
						# copy content from reference
						ref.text = refs[rid].text.lstrip("[]0123456789 \t")
						ref.extend(list(refs[rid]))

	#remove reference list
	back.remove(rlist)


print ElementTree.tostring(root)
