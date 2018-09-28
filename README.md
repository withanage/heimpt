![Heidelberg Monograph Publication  Tool (heiMPT)](https://raw.githubusercontent.com/withanage/heimpt/master/images/mpt.png)

**Heidelberg Monograph Publication Tool (heiMPT)** is a stand-alone platform, as well as a plug-in application for OMP, developed by staff of **Heidelberg University Library** in cooperation with external partners, with  fundings of  German Research Foundation ([DFG](http://www.dfg.de/)). It enables a high degree of automation in the digital publication process.
The platform consists of 4  modules: (1) typesetting (meTypeset), (2) xml-processor,  (3) an output generation engine and (4) a WYSIWYG editor.


(1) To convert from a Microsoft Word .docx format to NLM/JATS-XML for scholarly/scientific article typesetting, we utilize meTypeset, which we developed in collaboration with Dr. Martin Eve and the Public Knowledge Project (PKP). meTypeset is an extension/wrapper of OxGarage and uses TEI as an intermediary format to facilitate interchange. meTypeset allows for intelligent size processing of input documents and section grouping algorithms. It automatically detects figure and table lists, footnotes, heading structure, bibliographies, and metadata.

(2)  A Set of utilities to process the  XML files  and functions to manipulate the content. Some of the functions are numbering, sorting references, deleting unreferenced references etc.

(3) XML documents are converted to desired output formats that can then be offered to users, including HTML, PDF, and ePub.

(4)  The WYSIWYG editor, provides an interactive interface to confirm the information detected by meTypeset and to generate a suitable layout for the desired output format. The editor is written in both HTML and JavaScript, and handles data in XML format, so that each monograph is efficiently standardized and can be re-used. The editor is designed in a WYSIWYG (what you see is what you get) format that enables users to work with both text and images as they envision them.

![doc2pdf Pipeline](https://raw.githubusercontent.com/withanage/heimpt/master/images/mpt.png)

## Presentations
* PKP Conference, 2017 [Paper](https://pkp.sfu.ca/pkp2017/paper/view/565) [Slides](https://pkp.sfu.ca/pkp2017/paper/download/565/402) [:movie_camera: Video](https://www.youtube.com/watch?v=yOH1DS2EUck)


## Documentation
https://withanage.github.io/heimpt


## heiMPT Installation
 
Check if you have permissions to install in the `BUILD_DIR`
 
 ```
 BUILD_DIR=/usr/local
 git clone https://github.com/withanage/heimpt.git $BUILD_DIR/heimpt 
 cd $BUILD_DIR/heimpt
 git submodule update --init --recursive
 sudo pip install -r requirements.txt
 java -version 
 ```
 Optionally required
  ```
 cd editors/metadata/
 bower install 
 
 ```

### FO Processors 
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


### Test your  Installation
If your `$BUILD_DIR` differs from the previous path, change project path in `minimum_example.json`

```
python $BUILD_DIR/heimpt/heimpt.py  $BUILD_DIR/heimpt/configurations/minimum_example.json --debug
```
## Tests
```
pip install  -U pytest pytest-xdist pytest-json

```


## Credits

The lead developer is Dulip Withanage, Heidelberg University Library

Additional contributions were made, in (alphabetical order) by:

* Frank Krabbes, Heidelberg  University Library 
* Mayumi Ohta (Jun.2014 - Feb.2015), Cluster of Excellence, University Heidelberg
* Katharina Wäschle (Nov.2015- Oct.2016), Heidelberg University Library 
* Nils Weiher, Heidelberg University Library


