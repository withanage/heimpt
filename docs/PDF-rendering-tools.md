# Overview

| *test* | mPDF(CSS) | Prince(CSS) | FOP(FO) | AHF(FO) |
| :--- | :--- | :--- | :--- | :--- |
|||||
|**Links**||||
|||||
| PDF bookmarks | :white_check_mark:[:page_facing_up:](http://mpdf1.com/manual/index.php?tid=118) |  :white_check_mark: [:page_facing_up:](http://www.princexml.com/doc/pdf-bookmarks/) |  :white_check_mark: |  :white_check_mark: [:page_facing_up:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/bookmarks.ahf.pdf) |
| cross references |    | :white_check_mark: [:page_facing_up:](http://www.princexml.com/doc/7.1/cross-references/)   |  :white_check_mark: |  :white_check_mark: |
|||||
| **Foot- and endnotes** ||||
|||||
| endnotes |  :white_check_mark: |  :white_check_mark: |  :white_check_mark: |  :white_check_mark: |
| footnotes | :x:  |  :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/doubleColumned.prince.pdf) | :white_check_mark: |  :white_check_mark: [:page_facing_up:] (https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/footnotes.ahf.pdf)|
| page breaking footnotes | :x:  |  :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/doubleColumned.prince.pdf) |  :white_check_mark: |  :white_check_mark: |
| continuous footnotes | :x:  | :white_check_mark: | :x: |  :white_check_mark: :lock: |
| multi-column footnotes | :x:  |  :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/doubleColumned.prince.pdf) | :x: |  :white_check_mark: :lock: |
|||||
| **PDF versions** ||||
|||||
| PDF/A |  :white_check_mark: |  :white_check_mark:[:page_facing_up:](https://github.com/withanage/mpt/wiki/doc2pdf:-Reference-Excerpts#prince) |  :white_check_mark: |  :white_check_mark: |
| PDF/X | | :white_check_mark:[:page_facing_up:](https://github.com/withanage/mpt/wiki/doc2pdf:-Reference-Excerpts#prince) | partially, PDF/X-3:2003 only | :white_check_mark: (acc. to documentation) |
| PDF metadata ||:white_check_mark:[:page_facing_up:](http://www.princexml.com/doc/pdf-metadata/)|  :white_check_mark: (XMP) | :white_check_mark: (XMP) |
|||||
| **Columns**||||
|||||
| multi-column layout | :x: | :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/doubleColumned.prince.pdf)  |  :white_check_mark: | :white_check_mark:  [:page_facing_up:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/columns-ahf.pdf)|
| balanced columns | :x: | :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/doubleColumned.prince.pdf)  | :x: | :white_check_mark: |
|||||
| **Page flow**||||
|||||
| Facing pages |  | :white_check_mark: |  :white_check_mark: | :white_check_mark: |
| First page |  | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Last page |  | :x: | :white_check_mark: | :white_check_mark: |
| Forced odd/even page count |  | :x: | :white_check_mark: | :white_check_mark: |
|||||
| **Miscellaneous** ||||
|||||
| hyphenation dict |  :white_check_mark: |  :white_check_mark: |  :white_check_mark: |  :white_check_mark: |
| font embedding | | :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/fonts.prince.pdf) | | |
| image options | | :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/images.prince.pdf) | see below | see below |
| floating elements | |  :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/wrapAndFloat.prince.pdf) | (:white_check_mark:) | :white_check_mark: |
| text wrapping | | :white_check_mark:[:paperclip:](https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/wrapAndFloat.prince.pdf)  | :x: | :white_check_mark: :lock:|

# Test Reports

## Miscellaneous mPDF Tests

### Right-to-left Language Support :heavy_check_mark:

* :grey_exclamation: use an [OTL](http://mpdf1.com/manual/index.php?tid=502) font to display complex scripts

https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/rightToLeftFonts.pdf

### Footnote placement  :heavy_multiplication_x:

* neither mPDF nor Weasyprint currently support CSS footnotes
* instead, footnotes are handled as references and placed in the back of the document
* AHF implements additional footnote layout features that are not part of the XSL standard

https://github.com/withanage/mpt/blob/master/static/tests/misc/pdf/footnotes.pdf

## Habenstein Tests

[src (docx, xml)](https://github.com/withanage/mpt/tree/master/static/tests/habenstein/src)
[pdf](https://github.com/withanage/mpt/tree/master/static/tests/habenstein/pdf)

### Out Of The Box

* python vs PHP
* .orig.xml vs xml
* one .fo (Chapter 4)

https://github.com/withanage/mpt/tree/master/static/tests/habenstein/pdf/html2pdfOOTB

### PDF/A

* full document only (references)

https://github.com/withanage/mpt/blob/master/static/tests/habenstein/pdf/html2pdfA/hst.full.pdf

### Floating elements

Floating elements are layout elements (text boxes, images, tables, formulae etc.) which--unlike inline elements--can be taken out of the text flow to be placed on the next page or column--usually for fitting reasons.

FOP: Supports floats in a very basic way, but no text wrap around them.
AHF: Supports floats and text wrap. Proprietary options allow a finer adjustment of float placement.

The algorithms that place floating elements on the page seem to be very limited in FOP and AHF. E. g. the formatters cannot--in multicolumn layouts--be instructed to place a floating element at the bottom of the outer column if there is already one placed at the top of the inner column.

### Images

Stock FOP 2.0:
* Bitmap images: PNG working, uncompressed TIFF only
* Greyscale: TIFF - issues with Gamma
* RGB: TIFF format not fully supported (ZIP compression not working)
* CMYK: not working, crashes

FOP integrated in Oxygen 16
* JPEG: issues reading dimensions of the image (seems that FOP uses a standard of 72 dpi while ignoring the resolution defined in the image file)
* TIFF: less problematic, CMYK working
* PNG: no problems

AH6.2
* Seems to handle all cases well.

### Restrictions in multi column layouts

* Neither FOP nor AHF seems to support vertical justification of text. It can be tolerated in single column layouts but is a major aesthetic issue in multi column layouts: Columns may end uneven at the bottom of the page, which should be avoided.
* AHF and Prince support balanced columns, FOP does not.
