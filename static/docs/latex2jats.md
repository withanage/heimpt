
# Latex -> TEI -> JATS

## Prototype
> python /usr/local/mpt/static/tools/mpt.py /usr/local/mpt/static/tools/configurations/latex2jats.json

oder  für debugging

> python /usr/local/mpt/static/tools/mpt.py /usr/local/mpt/static/tools/configurations/latex2jats.json --debug

---

### Ausgabe
```
[MPT] PROJECT : tex2tei
[MPT] Step 1 :      pandoc
/usr/local/mpt/static/tests/latex2jats//tex2tei/2017_03_10-10-24-6e29f746/1_pandoc/xml
[MPT] Step 2 :      tei2tei
/usr/local/mpt/static/tests/latex2jats//tex2tei/2017_03_10-10-24-6e29f746/2_tei2tei/xml
[MPT] PROJECT : tei2jats
[MPT] Step 1 :      metypeset
/usr/local/mpt/static/tests/latex2jats//tei2jats/2017_03_10-10-24-6e29f746/1_metypeset/xml
```
----

#### Erklärung

- Ausgabe Ordner

> /usr/local/mpt/static/tests/latex2jats/ und /usr/local/mpt/static/tests/latex2jats//tei2jats/ 

-  1. Projekt tex2tei (aktiv)

> https://github.com/withanage/mpt/blob/master/static/tools/configurations/latex2jats.json#L2:L31

- 2. Projekt tei2jats (aktiv)

> https://github.com/withanage/mpt/blob/master/static/tools/configurations/latex2jats.json#L33:L47

- 3.Prjokt (1 und 2 zusammen) Zur Nicht Aktiv (er wird laufen, wenn Arne's  in 1.Projekt  meTypeset Valide TEI generieren)

> https://github.com/withanage/mpt/blob/master/static/tools/configurations/latex2jats.json#L52:L87

####  XSL im Server

> /usr/local/mpt/static/tools/tei2tei/pandoc2metypeset.xsl

#### git

> https://github.com/withanage/mpt/blob/master/static/tools/tei2tei/pandoc2metypeset.xsl

### Beispiel Datein

https://github.com/withanage/mpt/tree/master/static/tests/latex2jats



    
