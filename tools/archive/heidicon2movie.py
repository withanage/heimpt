#!/usr/bin/env python
# -*- coding: utf-8 -*-
import csv
import sys

output = open('/home/wit/Arbeit/OMP/Heiup/310/movies.xml', 'w')



with open(sys.argv[1], 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter='|', quotechar='"')
    #output.write('<xml>')

    for row in reader:
        output.write('<p><media content-type="play-in-place height-250 width-310" id="media{5}" mime-subtype="mov" mimetype="video" xlink:href="{2}">\
        <label>{0}</label><caption><title>{1}</title> <!-- <bold> </bold> -->              \
         <p><ext-link ext-link-type="doi" xlink:href="{3}">{3}</ext-link></p></caption><object-id  specific-use="poster">{4}</object-id></media></p>'.format(row[0],row[1],row[2].replace('&', '&amp;'),row[3],row[4],row[6]))
        output.write('\n')
    #output.write('</xml>')


csvfile.close()
output.close()