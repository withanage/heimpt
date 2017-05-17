Latex to TEI: Vorgehen
======================

* Tools: pandoc, perl, meTypeset
* Daten: finale Version von "Numerik\_0.tex" vom 28.3. (Datum in
  ub_pub: 30.3.)
* Dateien lokal (serv21): `/home/fit/latex2tei`

Testen mit Latex
----------------

Frage: Können wir hier dieselbe pdf-Datei als Output erzeugen, die wir
in der Datenlieferung erhalten haben?

### (pdf)latex (Versuch 1)

    pdflatex Numerik_0.tex 

### Fehler beheben

1. Fehlermeldung aus pst-coil: Zeile 93 in "pst-coil.tex" auskommentieren
2. Fehlermeldung Datei nicht gefunden: in Verzeichnis "Figures/" Name
  der Graphik anpassen:

  `mv Figures/AltnSatz.ps Figures/Altnsatz.ps`

3. unschöne Zeilenumbrüche (nur \r ohne \n): \r durch \n ersetzen in
  allen *.tex und *-sty-Dateien, die bei `head -5 <Datei>` nur eine
  Zeile zeigen:
  
```
    for f in pictex.tex postpictex.tex prepictex.tex pst-node.tex pst-plot.tex pstricks.tex multido.tex modifications.tex      Skriptum.sty rr.sty pstricks.sty pst-plot.sty pst-node.sty    multido.sty here.sty HD.sty float.sty equations.sty epsf.sty      doublespace.sty; do perl -n -i -e 's/\r/\n/g;print' $f; done
```
* 
```
    cd Figures
    for f in *.tex; do perl -n -i -e 's/\r/\n/g;print' $f; done
```

### (pdf)latex (Versuch 2)
```
    pdflatex Numerik_0.tex 
```

pandoc
------

### XML-Datei erzeugen (Versuch 1)
```
    pandoc -s Numerik_0.tex -t tei -o try.xml 
```
### Fehler beheben (Sonderzeichen in tex-Dateien)

#### anschauen im Terminal
```
find . -name '*tex' -print0 | sort -z | xargs -0 perl -e '$v=1;grep{$f="$_";print "\n=== Datei \"$f\" ===\n" if $v;open(A,"$f")||die "$!";while(<A>){chomp;s/\t/<TAB>/g;next unless /([\x00-\x1F]|[\x7F-\xFF])/;@f=split(//,$_);print "\nORIG: $_\n" if $v;grep{$char="$_";$dec=ord($char);if($char=~/([\x00-\x1F]|[\x7F-\xFF])/){print " $dec ($char) " if $v;$hc{$dec}++;$hb{$f}++}}@f;print "\n" if $v;};close A}@ARGV;print STDERR "\n\n== Welches Zeichen (dezimal (hex)) kommt wie oft vor (gesamt Ã¼ber alle Dateien):\n";foreach $k (sort keys %hc){$hex=sprintf(qq(%02X), $k);print "$k ($hex): $hc{$k}\n"};print "\n== Anzahl Zeichen in Datei:\n";foreach $k (sort keys %hb){print "$k:  $hb{$k}\n"}' | less
```

#### beheben (Achtung, *Überschreibt* Dateien!!!)
```
    for f in *tex; do perl -n -i -e 's/[\x7F-\xFF]//g;print' $f; done
    perl -n -i -e 's/[\x7F-\xFF]//g;print' doublespace.sty 
```
### XML-Datei erzeugen (Versuch 2)
```
    pandoc -s -t tei -o try.xml -f latex Numerik_0.tex
```

meTypeset
---------

### aufrufen (Versuch 1)

    rm -rf out1
    python /usr/local/meTypeset/bin/meTypeset.py tei try.xml \
      out1/ --nogit --debug

### Fehler beheben

* pandoc erzeugt das falsche `<title><p>...`
* pandoc schreibt Latex raus, das innerhalb von "formula" die Zeichen
  `&` und `<` enthÃ¤lt, diese hier ersetzen, da sonst das XML nicht
  valide ist

```
perl -ne 's/(<title>)<p>(.+)<\/p>(<\/title>)/$1$2$3/;s/(<\/formula>)/\nBRUCHZU $1/g;s/(<formula notation="TeX">)/$1 BRUCHAUF\n/g;print' try.xml | perl -ne '$p=0 if /BRUCHZU/;if($p){s/\&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g};$p=1 if /BRUCHAUF/;print'| perl -ne 'chomp if s/ BRUCHAUF//;print' | perl -ne 'chomp;if(s/BRUCHZU //){;}else{print "\n" unless $.==1};print;END{print "\n"}' > tryneu_BRUCH.xml
```

### aufrufen (Versuch 2)
```
    rm -rf out1
    python /usr/local/meTypeset/bin/meTypeset.py tei tryneu_BRUCH.xml \
      out1/ --nogit --debug
```
erzeugt derzeit Fehler: `KeyError: 'meTypesetSize'`

### weiteres Vorgehen

* In `heading`-Element Markup einfügen (`<hi rend="Heading 2"
meTypesetSize="90.0">`). Frage: Welche Elemente exakt? Wirklich
`hi`? Oder `head`?

* Status von "Metadata" klären, bislang fällt meTypeset auf einen Default zurück, der mit dem Numerik-Skript nichts zu tun hat:

`Metadata file wasn't specified. Falling back to
/usr/local/meTypeset/metadata/metadataSample.xml`

### Fehler beheben
```
    perl -ne 's/<head>/<head rend="Heading 2" meTypesetSize="90.0">/g;print' tryneu_BRUCH.xml > tryneu_metypesetsize.xml
```
`meTypesetSize` einfügen in alle `head`-Elemente

### aufrufen (Versuch 3)
```
    rm -rf out1
    python /usr/local/meTypeset/bin/meTypeset.py tei tryneu_metypesetsize.xml \
      out1/ --nogit --debug
```
### Ergebnis

'NoneType' object has no attribute 'remove'`...


