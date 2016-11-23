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
	fns = {}
	fnlist = back.find('fn-group')
	for fn in fnlist:
		fnid = fn.get('id')

#      <fn id="bibd2e58">
#        <p>	 For an explanation of the interview transcript abbreviations used throughout this work, see Appendix A.</p>
#      </fn>
		content = fn.find('p')
		fns[fnid] = content

	for sec in body.iter('sec'):
		for p in sec.iter('p'):
			for ref in p.iter('xref'):
				if ref.get('ref-type') == "fn":
					rid = ref.get('rid')
					if rid:
						# make xref a footnote
						ref.tag = 'footnote'
						# copy content from reference
						if fns.has_key(rid) and fns[rid] != None:
							ref.text = fns[rid].text.strip()
							ref.extend(list(fns[rid]))

	#remove reference list
	back.remove(fnlist)


print ElementTree.tostring(root)
