

Heidelberg Monograph Publication Tool **(heiMPT)** is a stand-alone platform, as well as a plug-in application for OMP, developed by staff of Heidelberg University Library in cooperation with external partners, with  fundings of  German Research Foundation (DFG). 
It enables a high degree of automation in **XML-first publication processes**.

heiMPT platform consists of independently executable modules for typesetting, xml-processing and output generation.
A  central module provides support for project specific configuration, tool setup and API integration.
Documentation refers explicitly to **JATS** and **BITS** XML formats from National Library of Medicine, but this tool suite can be used for any publishing automation process.
heiMPT interfaces with both Open Monograph Press **(OMP)** and Open Journal Systems **(OJS)** from Public Knowledge Project. 

* **heimpt.py**     : main tool for module integration 
* **Typesetting**   : (Input document into XML): any command-line compatible XML typesettings/conversion tool.   
* **prepare.py**    : post-processing JATS XML files for print and electronic publication. Supports functions such as auto numbering, sorting references, deleting unreferenced references etc.
* **merge.py**      : merges  several JATS/BITS XML Files together in a pre-defined order. 
* **disseminate.py**: XML documents are converted to desired output formats such as HTML, PDF, and ePub. Stylesheets are also available for further customizations.



![doc2pdf Pipeline](https://raw.githubusercontent.com/withanage/heimpt/master/images/mpt.png)


## Documentation
https://withanage.github.io/heimpt

##  Installation
 
 ```
 BUILD_DIR=/usr/local # or any directory
 git clone https://github.com/withanage/heimpt.git $BUILD_DIR/heimpt 
 cd $BUILD_DIR/heimpt
 git submodule update --init --recursive
 sudo pip install -r requirements.txt
 ```

#### Test your  Installation
If your `$BUILD_DIR` differs from the previous path, change project path in `example.json`

```
python $BUILD_DIR/heimpt/heimpt.py  \
    $BUILD_DIR/heimpt/configurations/example.json --debug
```

#### FO Processors 
Only needed if you generate PDF files.

* Apache FOP (free): Download from [Apache FOP processor](https://xmlgraphics.apache.org/fop/download.html) (Binary version) into `$BUILD_DIR/heimpt/tools`

```
cd $BUILD_DIR/heimpt/tools
tar -xvzf fop-2.2-bin.tar.gz;
mv fop-2.2 fop
chmod u+x fop/fop/fop
```

If you changed the default `$BUILD_DIR` in the installation step, set the path in fop.print.xml and fop.electronic.xml in `tools/configurations/fop/conf/` folder.

* Antenna- House(Commercial) : See the [distributor's](https://www.antennahouse.com) instructions
#### Tests
```
pip install  -U pytest pytest-xdist pytest-json
```
## Presentations
* PKP Conference, 2017 [Paper](https://pkp.sfu.ca/pkp2017/paper/view/565) [Slides](https://pkp.sfu.ca/pkp2017/paper/download/565/402) [:movie_camera: Video](https://www.youtube.com/watch?v=yOH1DS2EUck)

## Technology
* [PDF rendering tools evaluation](docs/PDF-rendering-tools.md)
* [Tools list](docs/pdf-tools.md) 
* [Longtime archiving support](docs/PDF-longtime-archiving.md)
* [Stylesheet-based conversion ](docs/saxon.md)
* [Experimental: latex ->TEI-XML -> JATS](docs/latex2tei2jats.md)
 



## Credits

The lead developer is Dulip Withanage, Heidelberg University Library

Additional contributions were made, in (alphabetical order) by:

* Frank Krabbes, Heidelberg  University Library 
* Mayumi Ohta (Jun.2014 - Feb.2015), Cluster of Excellence, University Heidelberg
* Katharina Wäschle (Nov.2015- Oct.2016), Heidelberg University Library 
* Nils Weiher, Heidelberg University Library

Software development tools

  [![](https://raw.githubusercontent.com/withanage/heimpt/master/images/pycharm_logo.png)]( https://www.jetbrains.com/pycharm/) PyCharm Python IDE

