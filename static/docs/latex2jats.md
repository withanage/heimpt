
# Latex -> TEI -> JATS

## Prototype
Program laufen

- normal modues

> python /usr/local/mpt/static/tools/mpt.py /usr/local/mpt/static/tools/configurations/latex2jats.json

- debug modus

> python /usr/local/mpt/static/tools/mpt.py /usr/local/mpt/static/tools/configurations/latex2jats.json --debug

---

### Ausgabe
```
> python /usr/local/mpt/static/tools/mpt.py /usr/local/mpt/static/tools/configurations/latex2jats.json
[MPT] PROJECT : tex2tei
[MPT] Step 1 :  pandoc
/usr/local/mpt/static/tests/latex2jats//tex2tei/2017_03_10-10-24-6e29f746/1_pandoc/xml
[MPT] Step 2 :  tei2tei
/usr/local/mpt/static/tests/latex2jats//tex2tei/2017_03_10-10-24-6e29f746/2_tei2tei/xml
[MPT] PROJECT : tei2jats
[MPT] Step 1 :  metypeset
/usr/local/mpt/static/tests/latex2jats//tei2jats/2017_03_10-10-24-6e29f746/1_metypeset/xml
```
----

#### Erklärung

- Ausgabe Ordner

> /usr/local/mpt/static/tests/latex2jats/ und /usr/local/mpt/static/tests/latex2jats//tei2jats/ 

-  Projekt 1   tex2tei (aktiv)

> https://github.com/withanage/mpt/blob/master/static/tools/configurations/latex2jats.json#L2:L31

- Projekt 2 tei2jats (aktiv)

> https://github.com/withanage/mpt/blob/master/static/tools/configurations/latex2jats.json#L33:L47


-  Projekt 3  (aktuell nicht aktiv)    ist eine Zusammenlegung (1 und 2)
-  wird ohne Fehler laufen, wenn Projekt 1 , valide Eingabe Dateien für Projekt 2 generieren

> https://github.com/withanage/mpt/blob/master/static/tools/configurations/latex2jats.json#L52:L87

####  XSL im Server

> /usr/local/mpt/static/tools/tei2tei/pandoc2metypeset.xsl

#### git

> https://github.com/withanage/mpt/blob/master/static/tools/tei2tei/pandoc2metypeset.xsl

### Beispiel Dateien

https://github.com/withanage/mpt/tree/master/static/tests/latex2jats



    
