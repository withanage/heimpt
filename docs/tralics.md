Tralics( Latex -&gt; XML)
=========================

![latex.png](https://raw.githubusercontent.com/withanage/mpt/master/static/images/tralics.png)


-   Sourcecode : [tralics](http://www-sop.inria.fr/marelle/tralics/)

Installation
------------

-   Current version
    [downlaod](ftp://ftp-sop.inria.fr/marelle/tralics/src/tralics-src-2.15.4.tar.gz)

<!-- -->

      cd /usr/local
      tar -xvzf tralics-src-2.15.4.tar.gz
      cd /usr/local/tralics-2.15.4/src
      make
      sudo ln -s /usr/local/tralics-2.15.4/src/tralics /usr/local/bin/tralics
      tralics

Run
---------

    tralics -utf8 -utf8output /path/datei.tex

generates /path/datei.xml
[options](http://www-sop.inria.fr/marelle/tralics/options.html)

external documentation
---------------------

-   [Tralics, a LaTeX to XML translator; Part
    I](http://www-sop.inria.fr/marelle/tralics/auxdir/tdoc1cid1.html#cid1)

-   [Tralics, a LaTeX to XML translator; Part
    II](http://www-sop.inria.fr/marelle/tralics/auxdir/tralics-rr2.html)

-   [Paper](http://www-sop.inria.fr/marelle/tralics/tralics-euro2003.pdf)

Python examples
---------------

``` {.python}
import subprocess
Arguments=['/usr/local/tralics-2.15.4/src/tralics', '-confdir', '/usr/local/tralics-2.15.4/confdir/', '-config', '/usr/localtralics-2.15.4/confdir/ra.tcf', '-utf8', '-utf8output', '/home/wit/hjo/gebhardt/gebhardt.tex']
Process = subprocess.call(Arguments)
```


Latex Templates
---------------

-   [Springer
    Template](https://www.springer.com/gp/authors-editors/book-authors-editors/manuscript-preparation/5636#c3324)

-   [Tufle-Latex](http://www.ctan.org/pkg/tufte-latex) ,
    [Beispiel](http://mirrors.ctan.org/macros/latex/contrib/tufte-latex/sample-book.pdf)

