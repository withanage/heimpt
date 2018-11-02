# Documentation XSL stylesheet for XSL FO generation

## Generic structure of the stylesheet

The stylesheet consists of two xsl files. "heiup_formatter.xsl" is the main xslt stylesheet. It includes (using xsl:include) an xslt "sub" file named "heiup_template_generic.xsl". The file name can be changed. While the main xslt stylesheet contains the general creation of the FO code, the "sub" file all configurable parameters and layout information. It provides a generic layout definition but can be modified for single projects as well as book series.

## Parameters for XSL transformation using the Saxon XSLT processor v. 6.7
```
java -jar saxon.jar -s:[xml source file] -xsl:[xsl stylesheet] \
    -o:[fo output] medium=[electronic | print] formatter=[FOP | AntennaHouse]
```

medium : triggers the output medium
* electronic : includes hyperlinking, PDF bookmarks and creates PDF/A (if supported by the formatter)
* print      : does not include hyperlinking or PDF navigation and creates PDF/X (if supported by the formatter)

formatter : triggers which proprietary code will be generated to include non standard FO functionality
* FOP          : proprietary code for the FOP formatter will be generated (e. g. PDF bookmarks)
* AntennaHouse : proprietary code for the Antenna House formatter will be generated