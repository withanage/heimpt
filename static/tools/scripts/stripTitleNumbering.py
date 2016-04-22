#!/usr/bin/python

import sys, copy
from xml.etree import ElementTree

f = sys.argv[1]
tree = ElementTree.parse(f)
root = tree.getroot()

for child in root:
	if child.tag == 'body':
		for sec in child.iter('sec'):
			for title in sec.iter('title'):
				stripped = title.text.lstrip("123456789.")
				if title.text != stripped:
					title.set('class', "numbered")
					title.text = stripped.lstrip(" \t")

print ElementTree.tostring(root)
