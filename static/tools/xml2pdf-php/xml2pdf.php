#!/usr/bin/php
<?php

/**
 * # Copyright 26-August-2016, 14:51:07
#
# Author    :Katharia Wäschle , University of Heidelberg
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
 */
/*
 * Convert XML to PDF with mpdf.
 */

include('./mpdf.php');

$longopts  = array(
		"output:",
		"xml:",
		"xsl:",
		"css:",
		"html:",	// optional
);

$options = getopt("o:", $longopts);

$xml_fn = $options["xml"];
$xsl_fn = $options["xsl"];
$out_fn = isset($options["output"]) ? $options["output"] : $options["o"];
$css_fn = $options["css"];
$html_fn = isset($options["html"]) ? $options["html"] : NULL;

// Load source documents
$xml = new DOMDocument;
$xml->load($xml_fn);

$xsl = new DOMDocument;
$xsl->load($xsl_fn);

// Initialize and configure XSLT processor
$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);

error_log("XML -> HTML ...");

$html = $proc->transformToDoc($xml);
// Save intermediate HTML (optional)
if ( isset($html_fn) ) { $html->save($html_fn); }
$html = $html->saveHTML();

error_log("... done");

// REMINDER: always import external stylsheets, otherwise mPDF is extremely slow
$css = file_get_contents($css_fn); // external css

error_log("HTML -> PDF ...");

$mpdf=new mPDF();
// PDF/A1-b compliance
$mpdf->PDFA = true;

// Convert HTML to PDF with CSS stylesheet
$mpdf->WriteHTML($css,1);
$mpdf->WriteHTML($html,2);
$mpdf->Output($out_fn);

error_log("... done");

exit;

?>
