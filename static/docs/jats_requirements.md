
JATS/BITS Metadata requirement-List from API
============================================

*This is a long-time metadata requirement list from API to support
automated print pdf production monographs. (Some of the requirements may
not be compulsory from OJS)*

General questions/ Ideas

-   How the language representation should happen in API? (minimum
    > duplication of tags, performance)

-   Should the client request language through content-negotiation or
    > using url-parameters?

| **[*&lt;boo | **XML Tag / | **OMP**     | **API**     | **Remarks** || k-part&gt;* | Attributes* |             |             |             |
| ](https://j | *           |             |             |             |
| ats.nlm.nih |             |             |             |             |
| .gov/extens |             |             |             |             |
| ions/bits/t |             |             |             |             |
| ag-library/ |             |             |             |             |
| 2.0/element |             |             |             |             |
| /book-part. |             |             |             |             |
| html)**     |             |             |             |             |
|             |             |             |             |             |
| [*Example*] |             |             |             |             |
| (https://gi |             |             |             |             |
| thub.com/wi |             |             |             |             |
| thanage/hei |             |             |             |             |
| mpt/blob/ma |             |             |             |             |
| ster/static |             |             |             |             |
| /tests/exam |             |             |             |             |
| ple/metadat |             |             |             |             |
| a/02_boxed_ |             |             |             |             |
| text.book-p |             |             |             |             |
| art-meta.bi |             |             |             |             |
| ts2.xml)    |             |             |             |             |
+=============+=============+=============+=============+=============+
| [***&lt;boo | -   *book-p | yes         | no          | *What is    |
| k-part-id&g | art-type="" |             |             | the best    |
| t;***](http | *           |             |             | way to get  |
| s://jats.nl |             |             |             | the         |
| m.nih.gov/e | -   *id="b1 |             |             | language?*  |
| xtensions/b | 1\_ch\_1"*  |             |             |             |
| its/tag-lib |             |             |             | *OJS        |
| rary/2.0/el | -   *seq="1 |             |             | section is  |
| ement/book- | "*          |             |             | available   |
| part-id.htm |             |             |             | in API*     |
| l)          | -   *xml:la |             |             |             |
|             | ng="de”*    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| [***&lt;tit | [***&lt;tit | yes         | yes         |             |
| le-group&gt | le&gt;***]( |             |             |             |
| ;***](https | https://jat |             |             |             |
| ://jats.nlm | s.nlm.nih.g |             |             |             |
| .nih.gov/ex | ov/extensio |             |             |             |
| tensions/bi | ns/bits/tag |             |             |             |
| ts/tag-libr | -library/2. |             |             |             |
| ary/2.0/ele | 0/element/t |             |             |             |
| ment/title- | itle.html)  |             |             |             |
| group.html) |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | [***subtitl | yes         | yes         |             |
|             | e***](https |             |             |             |
|             | ://jats.nlm |             |             |             |
|             | .nih.gov/ex |             |             |             |
|             | tensions/bi |             |             |             |
|             | ts/tag-libr |             |             |             |
|             | ary/2.0/ele |             |             |             |
|             | ment/subtit |             |             |             |
|             | le.html)    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | **[*&lt;tra | no          | no          | *Heidelberg |
|             | ns-title-gr |             |             | contributes |
|             | oup*](https |             |             | ([*Discussi |
|             | ://jats.nlm |             |             | on          |
|             | .nih.gov/ex |             |             | in          |
|             | tensions/bi |             |             | Technical   |
|             | ts/tag-libr |             |             | committee*] |
|             | ary/2.0/ele |             |             | (https://pk |
|             | ment/trans- |             |             | p.sfu.ca/wi |
|             | title-group |             |             | ki/index.ph |
|             | .html)&gt;* |             |             | p?title=Tec |
|             | *           |             |             | h_Committee |
|             |             |             |             | _Meeting_Mi |
|             | -   [***&lt |             |             | nutes_25_Ju |
|             | ;trans-titl |             |             | ly_2017#Ext |
|             | e&gt;***](h |             |             | ending_meta |
|             | ttps://jats |             |             | data_scheme |
|             | .nlm.nih.go |             |             | s_.28Dulip. |
|             | v/extension |             |             | 29))*       |
|             | s/bits/tag- |             |             |             |
|             | library/2.0 |             |             |             |
|             | /element/tr |             |             |             |
|             | ans-title.h |             |             |             |
|             | tml)        |             |             |             |
|             |             |             |             |             |
|             | -   [***&lt |             |             |             |
|             | ;trans-subt |             |             |             |
|             | itle&gt;*** |             |             |             |
|             | ](https://j |             |             |             |
|             | ats.nlm.nih |             |             |             |
|             | .gov/extens |             |             |             |
|             | ions/bits/t |             |             |             |
|             | ag-library/ |             |             |             |
|             | 2.0/element |             |             |             |
|             | /trans-subt |             |             |             |
|             | itle.html)  |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| [***&lt;con | [***&lt;con | yes         | part        | *OMP        |
| trib-group& | trib&gt;*** |             |             | records     |
| gt;***](htt | ](https://j |             |             | name parts  |
| ps://jats.n | ats.nlm.nih |             |             | independent |
| lm.nih.gov/ | .gov/extens |             |             | ly.*        |
| extensions/ | ions/bits/t |             |             |             |
| bits/tag-li | ag-library/ |             |             | *Clients    |
| brary/2.0/e | 2.0/element |             |             | such as     |
| lement/cont | /contrib.ht |             |             | citation    |
| rib-group.h | ml)         |             |             | generating  |
| tml)        |             |             |             | engines     |
| =========== | -   [***&lt |             |             | need the    |
| =========== | ;name&gt;** |             |             | name parts  |
| =========== | *](https:// |             |             | separately. |
| =========== | jats.nlm.ni |             |             | *           |
| =========== | h.gov/exten |             |             |             |
| =========== | sions/bits/ |             |             | *Outputting |
| =========== | tag-library |             |             | compound    |
| =========== | /2.0/elemen |             |             | names is    |
| =========== | t/name.html |             |             | also        |
| =========== | )           |             |             | necessary   |
| ====        |             |             |             | for         |
|             |     -   **& |             |             | convenience |
|             | lt;surname& |             |             | .*          |
|             | gt;**       |             |             |             |
|             |             |             |             | *Idea:*     |
|             |     -   **& |             |             |             |
|             | lt;given-na |             |             | *Returning  |
|             | mes&gt;**   |             |             | the name    |
|             |             |             |             | parts per   |
|             |     -   **& |             |             | url-paramet |
|             | lt;prefix&g |             |             | er*         |
|             | t;**        |             |             |             |
|             |             |             |             |             |
|             |     -       |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | [***&lt;aff | **Yes**     | **Yes**     | *should we  |
|             | &gt;***](ht |             |             | define the  |
|             | tps://jats. | **no**      | **no**      | affiliation |
|             | nlm.nih.gov |             |             | as a json   |
|             | /extensions |             |             | object , b  |
|             | /bits/tag-l |             |             | cause it    |
|             | ibrary/2.0/ |             |             | may contain |
|             | element/aff |             |             | more        |
|             | .html)      |             |             | metadata??? |
|             |             |             |             | *           |
|             | -   [*&lt;i |             |             |             |
|             | nstitution& |             |             |             |
|             | gt;*](https |             |             |             |
|             | ://jats.nlm |             |             |             |
|             | .nih.gov/ex |             |             |             |
|             | tensions/bi |             |             |             |
|             | ts/tag-libr |             |             |             |
|             | ary/2.0/ele |             |             |             |
|             | ment/instit |             |             |             |
|             | ution.html) |             |             |             |
|             |             |             |             |             |
|             | -   [***&lt |             |             |             |
|             | ;addr-line& |             |             |             |
|             | gt;***](htt |             |             |             |
|             | ps://jats.n |             |             |             |
|             | lm.nih.gov/ |             |             |             |
|             | extensions/ |             |             |             |
|             | bits/tag-li |             |             |             |
|             | brary/2.0/e |             |             |             |
|             | lement/addr |             |             |             |
|             | -line.html) |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | **[*&lt;xre | **yes**     | **yes**     | *Any        |
|             | f&gt;*](htt |             |             | cross-refer |
|             | ps://jats.n |             |             | ences       |
|             | lm.nih.gov/ |             |             | can be      |
|             | extensions/ |             |             | added into  |
|             | bits/tag-li |             |             | JATS*       |
|             | brary/2.0/e |             |             |             |
|             | lement/xref |             |             |             |
|             | .html)&lt;o |             |             |             |
|             | rcid&gt;**  |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | [***&lt;bio | **yes**     | **no**      |             |
|             | &gt;***](ht |             |             |             |
|             | tps://jats. |             |             |             |
|             | nlm.nih.gov |             |             |             |
|             | /extensions |             |             |             |
|             | /bits/tag-l |             |             |             |
|             | ibrary/2.0/ |             |             |             |
|             | element/bio |             |             |             |
|             | .html)      |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | [***&lt;ema | **yes**     | **no**      |             |
|             | il&gt;***]( |             |             |             |
|             | https://jat |             |             |             |
|             | s.nlm.nih.g |             |             |             |
|             | ov/extensio |             |             |             |
|             | ns/bits/tag |             |             |             |
|             | -library/2. |             |             |             |
|             | 0/element/b |             |             |             |
|             | io.html)    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | [***&lt;cou | **yes**     | **no**      |             |
|             | ntry&gt;*** |             |             |             |
|             | ](https://j |             |             |             |
|             | ats.nlm.nih |             |             |             |
|             | .gov/extens |             |             |             |
|             | ions/bits/t |             |             |             |
|             | ag-library/ |             |             |             |
|             | 2.0/element |             |             |             |
|             | /country.ht |             |             |             |
|             | ml)         |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | [***&lt;isb | **yes**     | **no**      |             |
|             | n&gt;***](h |             |             |             |
|             | ttps://jats |             |             |             |
|             | .nlm.nih.go |             |             |             |
|             | v/extension |             |             |             |
|             | s/bits/tag- |             |             |             |
|             | library/2.0 |             |             |             |
|             | /element/is |             |             |             |
|             | bn.html)    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| [***&lt;per | [*&lt;copyr | yes         | **no**      | *Omp        |
| missions&gt | ight-statem |             |             | includes a  |
| ;***](https | ent&gt;*](h |             |             | license-url |
| ://jats.nlm | ttps://jats |             |             | *           |
| .nih.gov/ex | .nlm.nih.go |             |             |             |
| tensions/bi | v/extension |             |             | *BITS       |
| ts/tag-libr | s/bits/tag- |             |             | mapping has |
| ary/2.0/ele | library/2.0 |             |             | to be       |
| ment/permis | /element/co |             |             | decided.*   |
| sions.html) | pyright-sta |             |             |             |
|             | tement.html |             |             | *General    |
|             | )           |             |             | Requirement |
|             |             |             |             | of print    |
|             | [*&lt;copyr |             |             | PDF is to   |
|             | ight-holder |             |             | get         |
|             | &gt;*](http |             |             | permissions |
|             | s://jats.nl |             |             | in          |
|             | m.nih.gov/e |             |             | &lt;multipl |
|             | xtensions/b |             |             | e&gt;       |
|             | its/tag-lib |             |             | languages.* |
|             | rary/2.0/el |             |             |             |
|             | ement/copyr |             |             |             |
|             | ight-holder |             |             |             |
|             | .html)      |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| [*&lt;autho | [*&lt;title | **no**      | **no**      | *omp        |
| r-comment&g | &gt;*](http |             |             | document    |
| t;*](https: | s://jats.nl |             |             | type can be |
| //jats.nlm. | m.nih.gov/e |             |             | used to     |
| nih.gov/ext | xtensions/b |             |             | support     |
| ensions/bit | its/tag-lib |             |             | this ??*    |
| s/tag-libra | rary/2.0/el |             |             |             |
| ry/2.0/elem | ement/title |             |             |             |
| ent/author- | .html)      |             |             |             |
| comment.htm |             |             |             |             |
| l)          | [*&lt;label |             |             |             |
|             | &gt;*](http |             |             |             |
|             | s://jats.nl |             |             |             |
|             | m.nih.gov/e |             |             |             |
|             | xtensions/b |             |             |             |
|             | its/tag-lib |             |             |             |
|             | rary/2.0/el |             |             |             |
|             | ement/label |             |             |             |
|             | .html)      |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| [*&lt;compo | [*&lt;subje | yes         | **no**      |             |
| und-subject | ct&gt;*](ht |             |             |             |
| &gt;*](http | tps://jats. |             |             |             |
| s://jats.nl | nlm.nih.gov |             |             |             |
| m.nih.gov/e | /extensions |             |             |             |
| xtensions/b | /bits/tag-l |             |             |             |
| its/tag-lib | ibrary/2.0/ |             |             |             |
| rary/2.0/el | element/sub |             |             |             |
| ement/compo | j-group.htm |             |             |             |
| und-subject | l)          |             |             |             |
| .html)      |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| [*&lt;kwd-g | [*&lt;kwd&g | yes         | **no**      | *Compound-* |
| roup&gt;*]( | t;*](https: |             |             | *keyword*   |
| https://jat | //jats.nlm. |             |             | *is a cool  |
| s.nlm.nih.g | nih.gov/ext |             |             | way in JATS |
| ov/extensio | ensions/bit |             |             | to address  |
| ns/bits/tag | s/tag-libra |             |             | lot of      |
| -library/2. | ry/2.0/elem |             |             | keyword     |
| 0/element/k | ent/kwd.htm |             |             | requirement |
| wd-group.ht | l)          |             |             | s.          |
| ml)         |             |             |             | Not         |
|             | [***&lt;com |             |             | obligatory, |
|             | pound-kwd&g |             |             | but worth a |
|             | t;***](http |             |             | look.*      |
|             | s://jats.nl |             |             |             |
|             | m.nih.gov/e |             |             |             |
|             | xtensions/b |             |             |             |
|             | its/tag-lib |             |             |             |
|             | rary/2.0/el |             |             |             |
|             | ement/compo |             |             |             |
|             | und-kwd.htm |             |             |             |
|             | l)          |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| **Full Book | **Book id** |             |             |             |
| Metadata**  |             |             |             |             |
|             |             |             |             |             |
| [***Example |             |             |             |             |
| file***](ht |             |             |             |             |
| tps://githu |             |             |             |             |
| b.com/witha |             |             |             |             |
| nage/heimpt |             |             |             |             |
| /blob/maste |             |             |             |             |
| r/static/te |             |             |             |             |
| sts/example |             |             |             |             |
| /metadata/E |             |             |             |             |
| xample_Full |             |             |             |             |
| .book-meta. |             |             |             |             |
| bits2.xml)  |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Book title  |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Book        |             |             |             |
|             | subtitle    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Contributor |             |             |             |
|             | (as in      |             |             |             |
|             | section)    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | ISBN        |             |             |             |
|             | Publication |             |             |             |
|             | format      |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | ISBN ID     |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| Publisher   | Publisher   |             |             |             |
|             | name        |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | Publisher   |             |             |             |
|             | language    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| Permissions | copyright-s |             |             |             |
|             | tatement    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             | copyright-y |             |             |             |
|             | ear         |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| Permissions | License-typ |             |             |             |
| -&gt;       | e           |             |             |             |
| license     |             |             |             |             |
|             | Lincense    |             |             |             |
|             | href        |             |             |             |
|             |             |             |             |             |
|             | License     |             |             |             |
|             | language    |             |             |             |
|             |             |             |             |             |
|             | Inline      |             |             |             |
|             | graphic     |             |             |             |
|             |             |             |             |             |
|             | License     |             |             |             |
|             | language    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| abstract    | Abstract in |             |             |             |
|             | language    |             |             |             |
+-------------+-------------+-------------+-------------+-------------+


