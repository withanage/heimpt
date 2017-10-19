
# Latex -> TEI -> JATS

* [Latex -&gt; TEI -&gt; JATS](#latex---tei---jats)
    * [Prototyp](#prototyp)
      * [Run](#run)
      * [Ausgabe](#ausgabe)
        * [Erklärung](#erklärung)
        * [TEI 2  TEI](#tei-2--tei)
      * [Beispiel Dateien (tex, tei, jats)](#beispiel-dateien-tex-tei-jats)

## Prototyp

### Run

- normal modus

> python /usr/local/heimpt/static/tools/mpt.py /usr/local/heimpt/static/tools/configurations/latex2jats.json

- debug modus

> python /usr/local/heimpt/static/tools/mpt.py /usr/local/heimpt/static/tools/configurations/latex2jats.json --debug

---

### Ausgabe
```
> python /usr/local/heimpt/static/tools/mpt.py /usr/local/heimpt/static/tools/configurations/latex2jats.json
[MPT] PROJECT : tex2tei
[MPT] Step 1 :  pandoc
/usr/local/heimpt/static/tests/latex2jats//tex2tei/2017_03_10-10-24-6e29f746/1_pandoc/xml
[MPT] Step 2 :  tei2tei
/usr/local/heimpt/static/tests/latex2jats//tex2tei/2017_03_10-10-24-6e29f746/2_tei2tei/xml
[MPT] PROJECT : tei2jats
[MPT] Step 1 :  metypeset
/usr/local/heimpt/static/tests/latex2jats//tei2jats/2017_03_10-10-24-6e29f746/1_metypeset/xml
```
----

#### Erklärung

- Ausgabe Ordner

> /usr/local/heimpt/static/tests/latex2jats/ 
> /usr/local/heimpt/static/tests/latex2jats//tei2jats/ 

-  Projekt 1 :  tex2tei (aktiv) 

> https://github.com/withanage/heimpt/blob/master/static/tools/configurations/latex2jats.json#L2:L31

- Projekt 2 : tei2jats (aktiv)

> https://github.com/withanage/heimpt/blob/master/static/tools/configurations/latex2jats.json#L33:L47


-  Projekt 3  : (nicht aktiv)    ist eine Zusammenlegung (1 und 2)
-  Zum Testen geeignet.

> https://github.com/withanage/heimpt/blob/master/static/tools/configurations/latex2jats.json#L52:L87

####  TEI 2  TEI
- Server
> /usr/local/heimpt/static/tools/tei2tei/pandoc2metypeset.xsl
- git
> https://github.com/withanage/heimpt/blob/master/static/tools/tei2tei/pandoc2metypeset.xsl

### Beispiel Dateien (tex, tei, jats)

https://github.com/withanage/heimpt/tree/master/static/tests/latex2jats



    
