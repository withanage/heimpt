

| [book-part](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/book-part.html) |    XML Tag / Attributes | OMP |  API | Remarks |
|----------|:-------------:|------:|------------:|-----:| 
| [book-part-id](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/book-part-id.html) | | yes | no | OJS section is available in API|
| [title-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title-group.html) |[title](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title.html) | yes | yes | |
| [title-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title-group.html) |[subtitle](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/subtitle.html) | yes | yes | |
| [title-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title-group.html) |[trans-title-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/trans-title-group.html) | no | no | [HD](https://pkp.sfu.ca/wiki/index.php?title=Tech_Committee_Meeting_Minutes_25_July_2017#Extending_metadata_schemes_.28Dulip.29)|
| [title-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title-group.html) |[trans-title](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/trans-title.html) | no | no | |
| [title-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title-group.html) |[trans-subtitle](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/trans-subtitle.html) | no | no | |
| [contrib-group](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/contrib-group.html) |[contrib](https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/contrib.html) | yes | part | OMP records name parts independently. Clients such as citation generating engines need the name parts separately. Outputting compound names is also necessary  for convenience. |






 



<td>no</td>
<td><h1 id="contrib-group"><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/contrib-group.html"><strong><em>&lt;contrib-group&gt;</em></strong></a></h1></td>
<td><p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/contrib.html"><strong><em>&lt;contrib&gt;</em></strong></a></p>
<ul>
<li><blockquote>
<p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/name.html"><strong><em>&lt;name&gt;</em></strong></a></p>
</blockquote>
<ul>
<li><blockquote>
<p><strong>&lt;surname&gt;</strong></p>
</blockquote></li>
<li><blockquote>
<p><strong>&lt;given-names&gt;</strong></p>
</blockquote></li>
<li><blockquote>
<p><strong>&lt;prefix&gt;</strong></p>
</blockquote></li>
<li></li>
</ul></li>
</ul></td>
<td>yes</td>
<td>part</td>
<td><p><em>.</em></p>
<p><em>Clients such as citation generating engines need the name parts separately.</em></p>
<p><em>Outputting compound names is also necessary for convenience.</em></p>
<p><em>Idea:</em></p>
<p><em>Returning the name parts per url-parameter</em></p></td>
</tr>
<tr class="even">
<td><h1 id="section"></h1></td>
<td><p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/aff.html"><strong><em>&lt;aff&gt;</em></strong></a></p>
<ul>
<li><blockquote>
<p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/institution.html"><em>&lt;institution&gt;</em></a></p>
</blockquote></li>
<li><blockquote>
<p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/addr-line.html"><strong><em>&lt;addr-line&gt;</em></strong></a></p>
</blockquote></li>
</ul></td>
<td><p><strong>Yes</strong></p>
<p><strong>no</strong></p></td>
<td><p><strong>Yes</strong></p>
<p><strong>no</strong></p></td>
<td><em>should we define the affiliation as a json object , b cause it may contain more metadata???</em></td>
</tr>
<tr class="odd">
<td><h1 id="section-1"></h1></td>
<td><strong><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/xref.html"><em>&lt;xref&gt;</em></a>&lt;orcid&gt;</strong></td>
<td><strong>yes</strong></td>
<td><strong>yes</strong></td>
<td><em>Any cross-references can be added into JATS</em></td>
</tr>
<tr class="even">
<td><h1 id="section-2"></h1></td>
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/bio.html"><strong><em>&lt;bio&gt;</em></strong></a></td>
<td><strong>yes</strong></td>
<td><strong>no</strong></td>
<td></td>
</tr>
<tr class="odd">
<td><h1 id="section-3"></h1></td>
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/bio.html"><strong><em>&lt;email&gt;</em></strong></a></td>
<td><strong>yes</strong></td>
<td><strong>no</strong></td>
<td></td>
</tr>
<tr class="even">
<td><h1 id="section-4"></h1></td>
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/country.html"><strong><em>&lt;country&gt;</em></strong></a></td>
<td><strong>yes</strong></td>
<td><strong>no</strong></td>
<td></td>
</tr>
<tr class="odd">
<td><h1 id="section-5"></h1></td>
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/isbn.html"><strong><em>&lt;isbn&gt;</em></strong></a></td>
<td><strong>yes</strong></td>
<td><strong>no</strong></td>
<td></td>
</tr>
<tr class="even">
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/permissions.html"><strong><em>&lt;permissions&gt;</em></strong></a></td>
<td><p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/copyright-statement.html"><em>&lt;copyright-statement&gt;</em></a></p>
<p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/copyright-holder.html"><em>&lt;copyright-holder&gt;</em></a></p></td>
<td>yes</td>
<td><strong>no</strong></td>
<td><p><em>Omp includes a license-url</em></p>
<p><em>BITS mapping has to be decided.</em></p>
<p><em>General Requirement of print PDF is to get permissions in &lt;multiple&gt; languages. </em></p></td>
</tr>
<tr class="odd">
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/author-comment.html"><em>&lt;author-comment&gt;</em></a></td>
<td><p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/title.html"><em>&lt;title&gt;</em></a></p>
<p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/label.html"><em>&lt;label&gt;</em></a></p></td>
<td><strong>no</strong></td>
<td><strong>no</strong></td>
<td><em>omp document type can be used to support this ??</em></td>
</tr>
<tr class="even">
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/compound-subject.html"><em>&lt;compound-subject&gt;</em></a></td>
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/subj-group.html"><em>&lt;subject&gt;</em></a></td>
<td>yes</td>
<td><strong>no</strong></td>
<td></td>
</tr>
<tr class="odd">
<td><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/kwd-group.html"><em>&lt;kwd-group&gt;</em></a></td>
<td><p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/kwd.html"><em>&lt;kwd&gt;</em></a></p>
<p><a href="https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/compound-kwd.html"><strong><em>&lt;compound-kwd&gt;</em></strong></a></p></td>
<td>yes</td>
<td><strong>no</strong></td>
<td><em>Compound-</em> <em>keyword</em> <em>is a cool way in JATS to address lot of keyword requirements. Not obligatory, but worth a look.</em></td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><strong>Full Book Metadata</strong></p>
<p><a href="https://github.com/withanage/heimpt/blob/master/static/tests/example/metadata/Example_Full.book-meta.bits2.xml"><strong><em>Example file</em></strong></a></p></td>
<td><strong>Book id </strong></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td>Book title</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td></td>
<td>Book subtitle</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td>Contributor (as in section)</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td></td>
<td>ISBN Publication format</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td>ISBN ID</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>Publisher</td>
<td>Publisher name</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td>Publisher language</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>Permissions</td>
<td>copyright-statement</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td>copyright-year</td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>Permissions -&gt; license</td>
<td><p>License-type</p>
<p>Lincense href</p>
<p>License language</p>
<p>Inline graphic</p>
<p>License language</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>abstract</td>
<td>Abstract in language</td>
<td></td>
<td></td>
<td></td>
</tr>

