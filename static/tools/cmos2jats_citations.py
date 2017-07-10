import re
import sys
from lxml import etree


cmos1='Heilman, James M., and Andrew G. West "Wikipedia and Medicine: Quantifying Readership, Editors, and the Significance of Natural Language." Journal of Medical Internet Research 17 no. 3 (2015) e62 doi:10.2196/jmir.4069'
cmos2='Knaller, Susanne. 2012. &#8220;The Ambiguousness of the Authentic:          Authenticity Between Reference, Fictionality, and Fake in Modern and Contemporary         Art.&#8221; In <italic>Authenticity: Contemporary Perspectives on a Critical            Concept</italic>, edited by Julia Straub, 51&#8211;75. Bielefeld:          transcript.'
cmos3='Susanne Knaller studied Romance and German Philology at the University of Graz. 2002 Habilitation (Romance Philology and General and Comparative Literature) at Johann-Wolfgang-Goethe-University Frankfurt. In 1999/2000 Fellow and in 2002/2003 Visiting Professor at Columbia University. Since 2002 Associate Professor at the University of Graz. Founder and Speaker of the Research Department General and Comparative Literature in Graz. Since 2013 Director of the Center of Cultural Studies at the University of Graz. A selection of recent publications includes: <italic>Ein Wort aus der Fremde. Geschichte und Theorie des Begriffs Authentizit&#228;t</italic> (2007); <italic>Realit&#228;tsbegriffe in der Moderne. Beitr&#228;ge zu Literatur, Kunst, Philosophie und Wissenschaft</italic>. (2011), edited with Harro M&#252;ller; <italic>Literaturwissenschaft heute &#8211; Gegenstand, Positionen, Relevanz </italic>(2013), edited with Doris Pichler; <italic>Realit&#228;t und Wirklichkeit in der Moderne. Texte zu Literatur, Kunst, Film und Fotografie </italic>(2013); and <italic>Die Realit&#228;t der Kunst. Programme und Theorien zu Literatur, Kunst und Fotografie seit 1700</italic> (2015); <italic>&#196;sthetische Emotion. Formen und Figurationen zur Zeit des Umbruchs der Medien und Gattungen (1880 &#8211; 1939)</italic> (2016), edited with Rita Rieger.'


#article_title = re.findall('<italic>(.*)</italic>',cmos2)
#journal_title = re.findall('\"(.*)\"',cmos1)
#person_group = re.split('^(\D+)',cmos2)

def clean(s):
    return s.strip().replace('\n', ' ').replace('\r', '') if s else s

def cre(s):
    return etree.Element(s)




def set_element_citations(t):
    rl = t.findall('.//mixed-citation')
    for r in rl:
        r.tag = 'element-citation'
        r.attrib['publication-type'] = "book"
        pr = clean(r.text)
        r.text = ''
        athrs = re.split('^(\D+)', pr) if pr else []
        pg = cre('person-group')
        pg.attrib['person-group-type'] = "author"
        n = cre("name")
        g = cre('given-names')
        # athrs_lst = athrs[1].split(',')
        # g.text=athrs_lst[1].rstrip('.')
        # n.append(g)
        s = cre('surname')
        # s.text = athrs_lst[0].rstrip('.')
        n.append(g)
        n.append(s)
        pg.append(n)
        r.append(pg)
        # for a in athrs.split(','):

        for i in r.findall('.//italic'):
            i.tag = 'article-title'
            tl = clean(i.tail)
            i.tail = ''
            s = cre('source')

            s.text = tl
            r.append(s)

            # print etree.tostring(r)


t = etree.parse(sys.argv[1])



def get_ref_sec(t):
    rl = t.findall('.//mixed-citation')
    sec_r = cre('sec')
    sec_t = cre('title')
    sec_t.text='References'
    sec_r.append(sec_t)
    for r in rl:
        r.tag = 'p'
        sec_r.append(r)
    return sec_r

bd = t.find('.//body')
bd.append(get_ref_sec(t))

rlst = t.find('.//ref-list')
rlst.getparent().remove(rlst)
rlback = t.find('.//back')
rlback.append(cre('ref-list'))



#set_element_citations(t)


t.write('output.xml', pretty_print=True, xml_declaration=True,   encoding="utf-8")