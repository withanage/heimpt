

Heidelberg Monograph Publication Tool **(heiMPT)** is a stand-alone platform, as well as a plug-in application for OMP, developed by staff of Heidelberg University Library in cooperation with external partners, with  funding of  German Research Foundation (DFG). 

It enables a high degree of automation in **XML-first publication processes**.

heiMPT platform consists of independently executable modules for typesetting, xml-processing and output generation.
A  central module provides support for project specific configuration, tool setup and API integration.
Documentation refers explicitly to **JATS** and **BITS** XML formats from National Library of Medicine, but this tool suite can be used for any publishing automation process.
 


* **heimpt.py**     : main tool for module integration 
* **Typesetting**   : (Input document into XML): any command-line compatible XML typesettings/conversion tool  
* **prepare.py**    : post-processing JATS XML files for print and electronic publication. Supports functions such as auto numbering, sorting references, deleting unreferenced references etc.
* **merge.py**      : merges  several JATS/BITS XML Files together in a pre-defined order. 
* **disseminate.py**: XML documents are converted to desired output formats such as HTML, PDF, and ePub. Stylesheets are also available for further customizations.



![doc2pdf Pipeline](https://raw.githubusercontent.com/withanage/heimpt/master/images/mpt.png)


## Installation
```bash
git clone https://github.com/withanage/heimpt
git submodule update --init --recursive --remote
sudo pip3 install -r requirements.txt 

```

## Presentations
* [:movie_camera: Video](https://www.youtube.com/watch?v=yOH1DS2EUck)

 


## Credits

The lead developer is Dulip Withanage, Heidelberg University Library

Additional contributions were made, in (alphabetical order) by:

* Frank Krabbes, Heidelberg  University Library 
* Mayumi Ohta (Jun.2014 - Feb.2015), Cluster of Excellence, University Heidelberg
* Katharina Wäschle (Nov.2015- Oct.2016), Heidelberg University Library 
* Nils Weiher, Heidelberg University Library

Software development tools

  [![](https://raw.githubusercontent.com/withanage/heimpt/master/images/pycharm_logo.png)]( https://www.jetbrains.com/pycharm/) PyCharm Python IDE

