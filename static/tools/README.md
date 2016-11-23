# Conversion pipeline test suite

## Installation

Clone the complete MPT repository.

```
git clone https://github.com/withanage/mpt.git
```

Initialize the submodules to get meTypeset.

```
cd mpt
git submodule update --init --recursive
```

[mPDF](http://www.mpdf1.com/mpdf/index.php?page=Installation) is included in MPT as the default PDF renderer. To use any of the other three supported tools, you need to install them separately.

 * [Antenna House Formatter](http://www.antennahouse.com/product/ahf60/download.htm)
 * [Apache FO](https://xmlgraphics.apache.org/fop/quickstartguide.html)
 * [Prince](http://www.princexml.com/download/)

## Test directory structure

MPT contains tests in ```./static/tests```. Every test collection is identified by a unique test name and stored in a subfolder, e.g. ```misc```. Input (and intermediate) files are stored in 

```
misc/src/doc
misc/src/xml
misc/src/html
misc/src/fo
```
respectively, output files (which will be generated automatically) in 
```
misc/pdf
```

A test is identified by a unique file name, which will be used to generate all intermediate and output files.

## Test configuration

Test settings are configured via a config file; an example file can be found in ```mpt/static/tools/test.cfg```. Specify

### General settings

* ```base_dir``` – path to your MPT installation
* ```test_collection``` – name of test collection directoryy, i.e. ```misc``` (see above)
* ```test_name``` – unique test identifier, e.g. ```footnotes```, name for all test files (```footnotes.doc```, ```footnotes.xml```, ...)


### Pipeline settings

* ```start``` – Per default, the pipeline starts at the first step (```1```), conversion from ```.doc```to ```.xml``` and performs all three conversion steps. If you want to start with a later step, e.g. after modifying the ```.xml```, specify ```2``` or ```3```. Make sure that the needed input files actually exist.

### Stylesheets

Stylesheets are needed to perform the various conversion sets. You can specify

* ```xslt_html```
* ```xslt_fo```
* ```css```

Some default stylesheets are included in ```../stylesheets```.

### PDF Renderers

Specifiy paths to all installed tools here,

* ```ahf```
* ```mpdf```
* ```prince```

If no path is specified, it will be assumed that the tool is not installed.

## Run test

```
./test.py -c config
```
