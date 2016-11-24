**FO Formatter Implementation**

<table>
<thead>
<tr class="header">
<th></th>
<th><strong>Standard XSL-FO</strong></th>
<th><strong>FOP 2.1</strong></th>
<th><strong>XEP 4.25</strong></th>
<th><strong>Antenna House Formatter 6.3</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>PDF Functions</strong></td>
</tr>
<tr class="even">
<td>Tagged PDF</td>
<td>no (proprietary)</td>
<td></td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Embedding of color profiles</td>
<td>no (proprietary)</td>
<td></td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>PDF Bookmarks</td>
<td>no (proprietary)</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>PDF Standard</strong><a href="#fn1" class="footnoteRef" id="fnref1"><sup>1</sup></a></td>
</tr>
<tr class="even">
<td>PDF/A-1a:2005</td>
<td>no (proprietary)</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>PDF/A-1b:2005</td>
<td>no (proprietary)</td>
<td><strong>yes</strong></td>
<td><strong>yes</strong></td>
<td>yes</td>
</tr>
<tr class="even">
<td>PDF/X-1a:2001</td>
<td>no (proprietary)</td>
<td>no</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>PDF/X-1a:2003</td>
<td>no (proprietary)</td>
<td>no</td>
<td>no</td>
<td>yes</td>
</tr>
<tr class="even">
<td>PDF/X-2:2003</td>
<td>no (proprietary)</td>
<td>no</td>
<td>no</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>PDF/X-3:2002</td>
<td>no (proprietary)</td>
<td>no</td>
<td><strong>yes</strong></td>
<td>yes</td>
</tr>
<tr class="even">
<td>PDF/X-3:2003</td>
<td>no (proprietary)</td>
<td><strong>partially</strong></td>
<td>no</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>PDF/X-4:2008</td>
<td>no (proprietary)</td>
<td>no</td>
<td>no</td>
<td>yes</td>
</tr>
<tr class="even">
<td><strong>PDF Metadata</strong></td>
</tr>
<tr class="odd">
<td>Dublin Core</td>
<td>no (proprietary)</td>
<td>yes</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>XMP</td>
<td>no (proprietary)</td>
<td>yes</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>Font support</strong></td>
</tr>
<tr class="even">
<td>TTF</td>
<td></td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>OTF</td>
<td></td>
<td>partially<a href="#fn2" class="footnoteRef" id="fnref2"><sup>2</sup></a></td>
<td>partially</td>
<td>yes</td>
</tr>
<tr class="even">
<td>Small Caps</td>
<td></td>
<td>no<a href="#fn3" class="footnoteRef" id="fnref3"><sup>3</sup></a></td>
<td>no</td>
<td>yes</td>
</tr>
<tr class="odd">
<td><strong>Page handling</strong></td>
</tr>
<tr class="even">
<td>Continuous</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Force odd page count</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>Force even page count</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>End on even page</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>End on odd page</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td><strong>Page Header</strong></td>
</tr>
<tr class="even">
<td>Proceedings</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Monograph</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td><blockquote>
<p>shorten too long header lines</p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>Page Footer</strong></td>
</tr>
<tr class="even">
<td>Display DOI and URN</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td><blockquote>
<p>Configurable for print and e-publication as well as proceedings and monographs</p>
</blockquote></td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td><strong>Headings</strong></td>
</tr>
<tr class="odd">
<td>Chapter title</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>Chapter subtitle</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Heading 1</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>Heading 2</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Heading 3</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>Heading 4</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Heading &gt; 4</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="even">
<td>Chapter numbering<br />
(hard coded in XML)</td>
<td>yes</td>
<td>yes</td>
<td></td>
<td>yes</td>
</tr>
<tr class="odd">
<td><blockquote>
<p>Indents for numbered headings</p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><strong>Footnotes / Endnotes</strong></td>
</tr>
<tr class="odd">
<td>Footnotes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="even">
<td><blockquote>
<p>Cross refs in epdf</p>
</blockquote></td>
<td>yes</td>
<td>yes<a href="#fn4" class="footnoteRef" id="fnref4"><sup>4</sup></a></td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Endnotes</td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p>Chapter backmatter</p>
</blockquote></td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td><blockquote>
<p>cross ref'd (epdf)</p>
</blockquote></td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="even">
<td><blockquote>
<p>book backmatter</p>
</blockquote></td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td><blockquote>
<p>cross ref'd (epdf)</p>
</blockquote></td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="even">
<td><blockquote>
<p>Book backmatter</p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>Cover Images</strong></td>
</tr>
<tr class="even">
<td>Front and back cover</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
<tr class="odd">
<td>Front and back cover inner pages</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
<td>yes</td>
</tr>
</tbody>
</table>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>Bold entries designate the default version if a not supported value for this particular formatter is used. For FOP the pdf standard can only be configured via the configuration file or command line parameter.<a href="#fnref1">↩</a></p></li>
<li id="fn2"><p>FOP 2.1: No support for advanced OTF features.<a href="#fnref2">↩</a></p></li>
<li id="fn3"><p>FOP 2.1: Only with dedicated small caps font.<a href="#fnref3">↩</a></p></li>
<li id="fn4"><p>FOP 2.1: Not working if OTF fonts are used; @line-height-shift-adjustment=&quot;disregard-shifts&quot; ignored if paragraph contains a basic-link element.<a href="#fnref4">↩</a></p></li>
</ol>
</div>
