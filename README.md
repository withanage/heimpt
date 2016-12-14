# Monograph Publication  Tool (MPT)

Monograph Publication Tool (MPT) is a stand-alone platform, as well as a plug-in application for OMP. Developed by University of Heidelberg staff in cooperation with external partners, it enables a high degree of automation in the digital publication process. Dulip Withanage of the University of Heidelberg Library supervises MPTs technical development.

The platform consists of 4  modules: (1) typesetting (meTypeset), (2) xml-processor,  (3) a WYSIWYG editor,and (4) an output generation engine.


(1) To covert from a Microsoft Word .docx format to NLM/JATS-XML for scholarly/scientific article typesetting, we utilize meTypeset, which Dulip Withanage developed in collaboration with Dr. Martin Eve and the Public Knowledge Project (PKP). meTypeset is an extension/wrapper of OxGarage and uses TEI as an intermediary format to facilitate interchange. meTypeset allows for intelligent size processing of input documents and section grouping algorithms. It automatically detects figure and table lists, footnotes, heading structure, bibliographies, and metadata.

(2)  A Set of utilities to process the  XML files  and functions to manipulate the content. Some of the functions are numbering, sorting references, deleting unreferenced references etc.

 (3)  The WYSIWYG editor, provides an interactive interface to confirm the information detected by meTypeset and to generate a suitable layout for the desired output format. The editor is written in both HTML and JavaScript, and handles data in XML format, so that each monograph is efficiently standardized and can be re-used. The editor is designed in a WYSIWYG (what you see is what you get) format that enables users to work with both text and images as they envision them.

(4) XML documents are converted to desired output formats that can then be offered to users, including HTML, PDF, and ePub.

![doc2pdf Pipeline](https://raw.githubusercontent.com/withanage/mpt/master/static/images/mpt.png)

## Prequisites
 * Python: `python --version`
 * Git: `git --version`

## MPT Installation 
Check if you have persmissions  to the BUILD_DIR
```
 BUILD_DIR=/usr/local
 git clone https://github.com/withanage/mpt.git $BUILD_DIR/mpt 
 cd $BUILD_DIR/mpt
 git submodule init
 git submodule update
```
only needed if you generate PDF
## FO Processors
* Apache FOP processor
```
cd $BUILD_DIR/mpt/static/tools
Download  (fop-2.1-bin.tar.gz)[https://xmlgraphics.apache.org/fop/download.html] or (direct link)[http://mirrors.cicku.me/apache/xmlgraphics/fop/binaries/fop-2.1-bin.tar.gz]
tar -xvzf fop-2.1-bin.tar.gz;
mv fop-2.1 fop
```
## Test
If your `$BUILD_DIR` differs from the previous path, change project path in `example.json`

```
python $BUILD_DIR/static/tools/mpt.py  $BUILD_DIR/static/tools/configurations/example.json --debug
```
## Update
```
cd $BUILD_DIR
git checkout master;git fetch; git pull; git submodule update
```

## API Documentation

https://withanage.github.io/mpt


## Credits

The lead developer is Dulip Withanage,  Heidelberg  University Library

  Additional contributions were made, in (alphabetical order) by:


* Frank Krabbes , Heidelberg  University Library 
* Mayumi Ohta, Cluster of Excellence,  University Heidelberg
* Katharina Wäschle, Heidelberg  University Library 

