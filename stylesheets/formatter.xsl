<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs"
    version="2.0">

    <!-- ******************************************************************
         * PDF Formatter for XSL FO 1.1             [Not for production!] *
         * Formatter                                                      *
         ******************************************************************
           First release to be published under 
           Creative Commons License CC BY-NC-ND 4.0
           (https://creativecommons.org/licenses/by-nc-nd/4.0/)

           See documentation for further information.

           Frank Krabbes
           Heidelberg University Library, Dept. Publication Services
           Plöck 107-109, 69117 Heidelberg, Germany
           Mail to: krabbes@ub.uni-heidelberg.de
    -->

    <!-- Section I. Parameters and configuration -->

    <!-- Output medium [mandatory]
            Controls a set of parameters such as PDF Standard, interactive functions or
            print optimizations. See style configurations file.
            Values: 
                interactive : interactive pdf
                print       : print pdf -->
    <xsl:param name="medium" as="xs:string" required="yes"/>

    <!-- FO Formatter used [mandatory]
            Controls the generation of formatter specific code, add-ons, extensions or optimizations.
            Values:
                plain : No formatter specific code or functions will be used,
                fop   : Apache FOP 2.2   (Open Source, https://xmlgraphics.apache.org/fop/2.2/)
                ah    : Antenna House 6.5 (Commercial, https://www.antennahouse.com/antenna1/formatter/)
            Remarks:
                RenderX XEP (http://www.renderx.com/tools/xep.html) and Altsoft XML2PDF Formatting Engine 
                (https://www.alt-soft.com/products/xml2pdf-formatting-engine/) are not officially supported. -->
    <xsl:param name="formatter" as="xs:string" required="yes"/>

    <!-- Include the style definitions and configurations file -->
    <xsl:include href="style.xsl"/>

    <!-- Section II: Formatter -->

    <!-- Language of the book taken from /book/@xml:lang -->
    <xsl:variable name="_bookLanguage">
        <xsl:choose>
            <xsl:when test="(/book/@xml:lang) and (/book/@xml:lang != '')">
                <xsl:value-of select="/book/@xml:lang"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$_defaultLanguage"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">

        <fo:root>

            <!-- ********************************************************** -->
            <!-- * Page templates and page sequence masters               * -->
            <!-- ********************************************************** -->

            <fo:layout-master-set>

                <!-- Page templates -->

                <!-- Blank page -->
                <fo:simple-page-master master-name="page_template_blank">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$_pageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$_pageWidth"/>
                    </xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>

                <!-- Simple pages (not containing header or footer)
                        Used for: half title, series title, frontispice, title page, copyright page, dedication, epigraph, 
                        second half title, part title and appendix title page -->

                    <!-- Even page -->
                    <fo:simple-page-master master-name="page_template_simple_even">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginOutside"/>
                        <xsl:attribute name="margin-right" select="$_marginInside"/>
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                    <!-- Odd page -->
                    <fo:simple-page-master master-name="page_template_simple_odd">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginInside"/>
                        <xsl:attribute name="margin-right" select="$_marginOutside"/>
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                <!-- Complex pages (containing header and footer, alternatives for first and last pages)
                        Used for all book contents not mentioned under "Simple pages" -->

                    <!-- First even page -->
                    <fo:simple-page-master master-name="page_template_first_even">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginOutside"/>
                        <xsl:attribute name="margin-right" select="$_marginInside"/>
                        <!-- No running titles on first page -->
                        <fo:region-after region-name="page_template_first_even_footer">
                            <xsl:attribute name="extent" select="$_footerExtent"/>
                        </fo:region-after>
                            <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                    <!-- First odd page -->
                    <fo:simple-page-master master-name="page_template_first_odd">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginInside"/>
                        <xsl:attribute name="margin-right" select="$_marginOutside"/>
                        <!-- No running titles on first page -->
                        <fo:region-after region-name="page_template_first_odd_footer">
                            <xsl:attribute name="extent" select="$_footerExtent"/>
                        </fo:region-after>
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                    <!-- Even page -->
                    <fo:simple-page-master master-name="page_template_even">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginOutside"/>
                        <xsl:attribute name="margin-right" select="$_marginInside"/>
                        <fo:region-before region-name="page_template_even_header">
                            <xsl:attribute name="extent" select="$_headerExtent"/>
                        </fo:region-before>
                        <fo:region-after region-name="page_template_even_footer">
                            <xsl:attribute name="extent" select="$_footerExtent"/>
                        </fo:region-after>
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                    <!-- Odd page -->
                    <fo:simple-page-master master-name="page_template_odd">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginInside"/>
                        <xsl:attribute name="margin-right" select="$_marginOutside"/>
                        <fo:region-before region-name="page_template_odd_header">
                            <xsl:attribute name="extent" select="$_headerExtent"/>
                        </fo:region-before>
                        <fo:region-after region-name="page_template_odd_footer">
                            <xsl:attribute name="extent" select="$_footerExtent"/>
                        </fo:region-after>
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                    <!-- Last even page -->
                    <fo:simple-page-master master-name="page_template_last_even">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginOutside"/>
                        <xsl:attribute name="margin-right" select="$_marginInside"/>
                        <fo:region-before region-name="page_template_even_header">
                            <xsl:attribute name="extent" select="$_headerExtent"/>
                        </fo:region-before>
                        <!-- No footer on a last page -->
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>

                    <!-- Last odd page -->
                    <fo:simple-page-master master-name="page_template_last_odd">
                        <xsl:attribute name="page-height" select="$_pageHeight"/>
                        <xsl:attribute name="page-width" select="$_pageWidth"/>
                        <xsl:attribute name="margin-top" select="$_marginTop"/>
                        <xsl:attribute name="margin-bottom" select="$_marginFoot"/>
                        <xsl:attribute name="margin-left" select="$_marginInside"/>
                        <xsl:attribute name="margin-right" select="$_marginOutside"/>
                        <fo:region-before region-name="page_template_odd_header">
                            <xsl:attribute name="extent" select="$_headerExtent"/>
                        </fo:region-before>
                        <!-- No footer on a last page -->
                        <fo:region-body>
                            <xsl:attribute name="margin-top" select="$_typeAreaMarginTop"/>
                            <xsl:attribute name="margin-bottom" select="$_typeAreaMarginFoot"/>
                            <xsl:attribute name="margin-left" select="$_typeAreaMarginOutside"/>
                            <xsl:attribute name="margin-right" select="$_typeAreaMarginInside"/>
                        </fo:region-body>
                    </fo:simple-page-master>
                
                <!-- Page sequence definitions -->

                    <!-- Simple page sequence -->

                    <fo:page-sequence-master master-name="simple_page_sequence">
                        <fo:repeatable-page-master-alternatives>
                            <fo:conditional-page-master-reference odd-or-even="odd"  page-position="first" blank-or-not-blank="not-blank" master-reference="page_template_simple_odd"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="first" blank-or-not-blank="not-blank" master-reference="page_template_simple_even"/>
                            <fo:conditional-page-master-reference odd-or-even="odd"  page-position="rest"  blank-or-not-blank="not-blank" master-reference="page_template_simple_odd"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="rest"  blank-or-not-blank="not-blank" master-reference="page_template_simple_even"/>
                            <fo:conditional-page-master-reference odd-or-even="odd"  page-position="last"  blank-or-not-blank="not-blank" master-reference="page_template_simple_odd"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="last"  blank-or-not-blank="not-blank" master-reference="page_template_simple_even"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="last"  blank-or-not-blank="blank"     master-reference="page_template_blank"/>
                        </fo:repeatable-page-master-alternatives>
                    </fo:page-sequence-master>

                    <!-- Complex page sequence -->

                    <fo:page-sequence-master master-name="complex_page_sequence">
                        <fo:repeatable-page-master-alternatives>
                            <fo:conditional-page-master-reference odd-or-even="odd"  page-position="first" blank-or-not-blank="not-blank" master-reference="page_template_first_odd"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="first" blank-or-not-blank="not-blank" master-reference="page_template_first_even"/>
                            <fo:conditional-page-master-reference odd-or-even="odd"  page-position="rest"  blank-or-not-blank="not-blank" master-reference="page_template_odd"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="rest"  blank-or-not-blank="not-blank" master-reference="page_template_even"/>
                            <fo:conditional-page-master-reference odd-or-even="odd"  page-position="last"  blank-or-not-blank="not-blank" master-reference="page_template_last_odd"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="last"  blank-or-not-blank="not-blank" master-reference="page_template_last_even"/>
                            <fo:conditional-page-master-reference odd-or-even="even" page-position="last"  blank-or-not-blank="blank"     master-reference="page_template_blank"/>
                        </fo:repeatable-page-master-alternatives>
                    </fo:page-sequence-master>

            </fo:layout-master-set>

            <!-- ********************************************************** -->
            <!-- * Declarations                                           * -->
            <!-- ********************************************************** -->            

            <fo:declarations>

                <xsl:if test="$formatter='ah'">

                    <!-- For options refer to 
                        https://www.antennahouse.com/product/ahf65/ahf-ext.html#axf.document-info -->

                    <!-- PDF Metadata -->

                    <!-- Document title -->
                    <xsl:if test="/book/book-meta/book-title-group/book-title">
                        <xsl:element name="axf:document-info">
                            <xsl:attribute name="name">document-title</xsl:attribute>
                            <xsl:attribute name="value">
                                <xsl:value-of select="/book/book-meta/book-title-group/book-title"/>
                                <xsl:if test="/book/book-meta/book-title-group/subtitle">
                                    <xsl:text>. </xsl:text>
                                    <xsl:value-of select="/book/book-meta/book-title-group/subtitle"/>
                                </xsl:if>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>

                    <!-- Contributor names -->
                    <xsl:choose>
                        <xsl:when test="/book[@book-type='proceedings']">
                            <xsl:if test="/book/book-meta/contrib-group/contrib[@contrib-type='pbd']">
                                <xsl:element name="axf:document-info">
                                    <xsl:attribute name="name">author</xsl:attribute>
                                    <xsl:attribute name="value">
                                        <xsl:call-template name="contributor_names">
                                            <xsl:with-param name="_contrib-type">pbd</xsl:with-param>
                                            <xsl:with-param name="_xpath-expression">/book/book-meta/contrib-group/</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="/book[@book-type='monograph']">
                        </xsl:when>
                        <xsl:when test="/book[@book-type='lexicon']">
                        </xsl:when>
                        <xsl:otherwise>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <axf:document-info name="subject" value="The document subject"/>
                    <axf:document-info name="keywords" value="Comma separated keywords list"/>

                    <!-- PDF display options -->

                    <axf:document-info name="pagelayout" value="TwoPageRight"/>
                    <axf:document-info name="displaydoctitle" value="true"/>
                    <xsl:if test="$medium='interactive' and $_pdf_bookmarks='yes'">
                        <axf:document-info name="pagemode" value="UseOutlines"/>
                    </xsl:if>

                    <!-- PDF output options -->
                    
                    <!-- PDF version -->
                    <axf:formatter-config xmlns:axs="http://www.antennahouse.com/names/XSL/Settings">
                         <xsl:choose>
                            <xsl:when test="$medium='interactive'">
                                <axs:pdf-settings tagged-pdf="true">
                                    <xsl:attribute name="pdf-version">
                                        <xsl:value-of select="$_interactive-pdf-version"/>
                                    </xsl:attribute>
                                </axs:pdf-settings>                    
                            </xsl:when>
                            <xsl:when test="$medium='print'">
                                <axs:pdf-settings tagged-pdf="true">
                                    <xsl:attribute name="pdf-version">
                                        <xsl:value-of select="$_non-interactive-pdf-version"/>
                                    </xsl:attribute>
                                </axs:pdf-settings>
                            </xsl:when>
                        </xsl:choose>
                        
                        <axs:formatter-settings zwsp-mode="6"/>
                        
                    </axf:formatter-config>
                    
                    <!-- Color profile embedding -->
                    <xsl:choose>
                        <xsl:when test="$medium='interactive' and $_interactive-pdf-color-profile!=''">
                            <fo:color-profile>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$_interactive-pdf-color-profile"/>
                                </xsl:attribute>
                            </fo:color-profile>                            
                        </xsl:when>
                        <xsl:when test="$medium='print' and $_non-interactive-pdf-color-profile!=''">
                            <fo:color-profile>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$_non-interactive-pdf-color-profile"/>
                                </xsl:attribute>
                            </fo:color-profile>
                        </xsl:when>
                    </xsl:choose>
                    
                    <!-- File name postfix for multi-file output -->
                    <axf:output-volume-info initial-volume-number="1" format="-1" bookmark-include="separate"/>

                </xsl:if>

            </fo:declarations>

            <!-- ********************************************************** -->
            <!-- * Bookmark Tree                                          * -->
            <!-- ********************************************************** -->

            <xsl:call-template name="pdf_bookmarks"/>

            <!-- ********************************************************** -->
            <!-- * Formatting                                             * -->
            <!-- ********************************************************** -->

            <!-- Front cover -->

            <!-- [...] -->

            <!-- Preliminaries -->
            
            <xsl:call-template name="prelimiaries"/>

            <!-- Front matter -->

            <xsl:apply-templates select="/book/front-matter" mode="typesetting"/>

            <!-- Text -->

            <xsl:apply-templates select="/book/book-body" mode="typesetting"/>            

            <!-- Back matter -->

            <xsl:apply-templates select="/book/book-back" mode="typesetting"/>

            <!-- Back cover -->

            <!-- [...] -->

        </fo:root>

    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Templates for typesetting                              * -->
    <!-- ********************************************************** -->

    <!-- * Generic book divisions ********************************* -->

    <!-- Book cover -->
    <!-- [...] -->

    <!-- Preliminaries: half title, series title, main title, copyright page (simple page model) -->
    <xsl:template name="prelimiaries">
        <fo:page-sequence master-reference="simple_page_sequence" force-page-count="even" initial-page-number="1">
            <xsl:attribute name="format">
                <xsl:choose>
                    <xsl:when test="/book/@book-type='monograph'">
                        <xsl:value-of select="$_front-matterMonographPagination"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='proceedings'">
                        <xsl:value-of select="$_front-matterProceedingsPagination"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>i</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <fo:flow flow-name="xsl-region-body">
                
                <!-- Half title -->
                <xsl:element name="fo:block" use-attribute-sets="half_title">
                    <xsl:attribute name="page-break-after">always</xsl:attribute>
                    <xsl:attribute name="id">prelims</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="/book/book-meta/book-title-group/book-title">
                            <xsl:apply-templates select="/book/book-meta/book-title-group/book-title" mode="typesetting"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                
                <!-- Series title page -->

                <xsl:if test="/book/collection-meta">
                    
                    <!-- Series title -->
                    <xsl:if test="/book/collection-meta/title-group/title">
                        <xsl:element name="fo:block" use-attribute-sets="series_title">
                            <xsl:apply-templates select="/book/collection-meta/title-group/title" mode="typesetting"/>
                        </xsl:element>
                    </xsl:if>
                    
                    <!-- Series subtitle -->
                    <xsl:if test="/book/collection-meta/title-group/subtitle">
                        <xsl:element name="fo:block" use-attribute-sets="series_subtitle">
                            <xsl:apply-templates select="/book/collection-meta/title-group/subtitle" mode="typesetting"/>
                        </xsl:element>
                    </xsl:if>
                    
                    <!-- Series editors -->
                    <xsl:if test="/book/collection-meta/contrib-group/contrib[@contrib-type='pbd']">

                        <xsl:element name="fo:block" use-attribute-sets="series_edited_by_phrase">
                        
                            <!-- "Series edited by" phrase -->
                            <xsl:choose>
                                <xsl:when test="$_localization/localization-group[@name='series_edited_by_phrase']/localization-item[@xml:lang=$_bookLanguage]">
                                    <xsl:value-of select="$_localization/localization-group[@name='series_edited_by_phrase']/localization-item[@xml:lang=$_bookLanguage]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Series Editors:</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:element>
                            
                        <xsl:element name="fo:block" use-attribute-sets="series_editors">
                                
                            <!-- Series editors -->
                            <xsl:for-each select="/book/collection-meta/contrib-group/contrib[@contrib-type='pbd']">

                                <!-- Series editor name -->
                                <xsl:if test="position() > 1">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="name/given-names"/><xsl:text>&#160;</xsl:text><xsl:value-of select="name/surname"/>
                            
                                <!-- Affiliation -->
                                <xsl:if test="aff">
                                    <xsl:text>, </xsl:text>
                                    <xsl:value-of select="aff"/>
                                </xsl:if>
                            </xsl:for-each>

                        </xsl:element>

                    </xsl:if>
                    
                </xsl:if>                

                <xsl:element name="fo:block" use-attribute-sets="series_title">
                    <xsl:attribute name="page-break-after">always</xsl:attribute>
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
                
                <!-- Main title -->
                <fo:block page-break-after="always">main title</fo:block>
                
                <!-- Copyright page -->
                <fo:block>copyright page</fo:block>
                
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    
    <xsl:template match="front-matter" mode="typesetting">
        
        <!-- Dedication and Epigraph -->
        <xsl:apply-templates select="dedication | front-matter-part[@book-part-type='epigraph']" mode="#current"/>

        <!-- Inhaltsübersicht -->
        <!-- [...] --> 
        
        <!-- Inhaltsverzeichnis -->
        <xsl:if test="parent::book">
            <xsl:call-template name="table-of-contents"/>
        </xsl:if>
        
        <!-- All other front matter sections -->
        <xsl:apply-templates select="ack | bio | foreword | front-matter-part[not(@book-part-type='epigraph')] | glossary | notes | preface | ref-list" mode="#current"/>
        
    </xsl:template>

    <xsl:template match="book-body" mode="typesetting">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <xsl:template match="book-back" mode="typesetting">
        <xsl:apply-templates select="ack | bio | book-app | book-app-group | book-part | dedication | fn-group | glossary | notes | ref-list" mode="#current"/>
    </xsl:template>

    <!-- Back cover -->
    <!-- [...] -->

    <!-- * Book divisions ***************************************** -->

    <!-- Dedication and epigraph (simple page model) -->
    <xsl:template match="dedication | front-matter-part[@book-part-type='epigraph']" mode="typesetting">

        <fo:page-sequence master-reference="simple_page_sequence" force-page-count="even">
            <xsl:call-template name="page_number"/>
           
            <!-- Insert ID for internal referencing -->
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
           
            <!-- Text flow -->
           
            <fo:flow flow-name="xsl-region-body">
               
                <!-- Title block -->
                <xsl:apply-templates select="book-part-meta" mode="#current"/>
               
                <!-- Body -->                
                <xsl:apply-templates select="named-book-part-body" mode="#current"/>
              
                <!-- Back matter -->
                <xsl:apply-templates select="back" mode="#current"/>
               
            </fo:flow>
                    
        </fo:page-sequence>
            
    </xsl:template>

    <!-- Forword, preface and front matter part -->
    <xsl:template match="foreword | preface | front-matter-part" mode="typesetting">

        <xsl:choose>
            
            <!-- Foreword, Preface and Front-Matter-Part are transformed in a fo:page-sequence if they are
                 - a section in a group of appendices (parent::book-app-group)
                 - a section in a book backmatter (parent::book-back)
                 - a section in a group of chapters (parent::book-part-wrapper)
                 - a section in the book front matter (parent::front-matter[parent::book])
                 - a section in the front matter of a part (parent::front-matter[parent::book-part[@book-part-type='part']]) -->
            <xsl:when test="parent::book-app-group or parent::book-back or parent::book-part-wrapper or parent::front-matter[parent::book] or parent::front-matter[parent::book-part[@book-part-type='part']]">
                
               <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
                    <xsl:call-template name="page_number"/>
            
                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
            
                    <!-- Footnote separator line -->
                    <xsl:call-template name="footnote_separator_line"/>
            
                    <!-- Static content -->
                    <xsl:call-template name="static_content"/>
            
                    <!-- Text flow -->
            
                    <fo:flow flow-name="xsl-region-body">
                    
                        <!-- Title block -->
                        <xsl:apply-templates select="book-part-meta" mode="#current"/>
                
                        <!-- Body -->                
                        <xsl:apply-templates select="named-book-part-body" mode="#current"/>
                
                        <!-- Chapter level section backmatter -->
                        <xsl:apply-templates select="back" mode="#current"/>
                    
                    </fo:flow>
            
                </fo:page-sequence>
        
            </xsl:when>
            
            <xsl:otherwise>

                <!-- Title block -->
                <xsl:apply-templates select="book-part-meta" mode="#current"/>
                
                <!-- Body -->                
                <xsl:apply-templates select="named-book-part-body" mode="#current"/>
                
                <!-- Chapter level section backmatter -->
                <xsl:apply-templates select="back" mode="#current"/>
                
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>

    <!-- Acknowledgement, bio and notes -->
    <xsl:template match="ack | bio | notes | app-group | app" mode="typesetting">

        <xsl:choose>
            
            <!-- Acknowledgements and Notes are transformed in a fo:page-sequence if they are
                 - a section in a group of appendices (parent::book-app-group)
                 - a section in a book backmatter (parent::book-back)
                 - a section in a group of chapters (parent::book-part-wrapper)
                 - a section in the book front matter (parent::front-matter[parent::book])
                 - a section in the front matter of a part (parent::front-matter[parent::book-part[@book-part-type='part']]) -->
            <xsl:when test="parent::book-app-group or parent::book-back or parent::book-part-wrapper or parent::front-matter[parent::book] or parent::front-matter[parent::book-part[@book-part-type='part']]">
                <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
                    <xsl:call-template name="page_number"/>
                    
                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <!-- Footnote separator line -->
                    <xsl:call-template name="footnote_separator_line"/>
                    
                    <!-- Static content -->
                    <xsl:call-template name="static_content"/>
                    
                    <!-- Text flow -->
                    
                    <fo:flow flow-name="xsl-region-body">
                        
                        <!-- Title block -->
                        <xsl:call-template name="chapter-heading"/>
                        
                        <!-- Body -->
                        <xsl:apply-templates select="node() except label except title except subtitle except sec-meta" mode="#current"/>
                        
                    </fo:flow>
                    
                </fo:page-sequence>
                
            </xsl:when>
            <xsl:otherwise>
                
                <!-- Title block -->
                <xsl:call-template name="chapter-heading"/>
                
                <!-- Body -->
                <xsl:apply-templates select="node() except label except title except subtitle except sec-meta" mode="#current"/>
                
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Glossaries -->
    <xsl:template match="glossary" mode="typesetting">

        <xsl:choose>

            <!-- Top level glossaries start a new section. Sub-glossaries do not -->
            <xsl:when test="parent::book-back or parent::book-part-wrapper or parent::front-matter[parent::book] or parent::front-matter[parent::book-part[@book-part-type='part']]">

                <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
                    <xsl:call-template name="page_number"/>
                    
                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <!-- Footnote separator line -->
                    <xsl:call-template name="footnote_separator_line"/>
                    
                    <!-- Footers -->
                    
                    <!-- First odd page -->
                    <fo:static-content flow-name="page_template_first_odd_footer">
                        <xsl:call-template name="static_footer_first_odd_page"/>
                    </fo:static-content>
                    
                    <!-- First even page -->
                    <fo:static-content flow-name="page_template_first_even_footer">
                        <xsl:call-template name="static_footer_first_even_page"/>
                    </fo:static-content>
                    
                    <!-- Odd page -->
                    <fo:static-content flow-name="page_template_odd_footer">
                        <xsl:call-template name="static_footer_odd_page"/>
                    </fo:static-content>
                    
                    <!-- Even page -->
                    <fo:static-content flow-name="page_template_even_footer">
                        <xsl:call-template name="static_footer_even_page"/>
                    </fo:static-content>
                    
                    <!-- Headers -->

                    <!-- Odd page -->
                    <fo:static-content flow-name="page_template_odd_header">
                        <xsl:call-template name="static_header_odd_page"/>
                    </fo:static-content>
                    
                    <!-- Even page -->
                    <fo:static-content flow-name="page_template_even_header">
                        <xsl:call-template name="static_header_even_page"/>
                    </fo:static-content>
                    
                    <!-- Text flow -->

                    <fo:flow flow-name="xsl-region-body">

                        <!-- Title block -->
                        <xsl:call-template name="chapter-heading"/>
                        
                        <!-- Body -->
                        <xsl:apply-templates select="node() except label except title" mode="#current"/>

                        <!-- Chapter level section backmatter -->
                        <xsl:apply-templates select="back" mode="#current"/>
                        
                    </fo:flow>

                </fo:page-sequence>

            </xsl:when>

            <!-- Sub glossaries -->
            <xsl:otherwise>

                <!-- Heading -->
                <xsl:if test="label or title">
                    <xsl:call-template name="chapter-heading"/>
                </xsl:if>

                <!-- Body -->
                <xsl:apply-templates select="node() except label except title" mode="#current"/>

            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <!-- Book parts (simple page model), book chapters, and appendices -->
    <xsl:template match="book-part | book-app | book-app-group" mode="typesetting">

        <!-- Book part can contain three types of book parts:
            (1) Book parts
            (2) Chapters or appendices -->

        <xsl:choose>
            
            <!-- Book parts and Grouped appendices get a starter page -->
            <xsl:when test="@book-part-type='part' or self::book-app-group">
                
                <!-- Book part -->
                
                <!-- Create (1) a part starter page -->
                <fo:page-sequence master-reference="simple_page_sequence" force-page-count="even">

                    <!-- Distinctions relevant for pagination -->
                    <xsl:if test="not(preceding-sibling::book-part) and not(ancestor::book-part) and not(ancestor::book-back)">
                        <xsl:if test="(/book/@book-type='monograph' and $_front-matterMonographPagination!='1') or (/book/@book-type='proceedings' and $_front-matterProceedingsPagination!='1') or (not(/book/@book-type)) or (/book/@book-type!='monograph' and /book/@book-type!='proceedings')">
                            <xsl:attribute name="initial-page-number">1</xsl:attribute>
                            <xsl:attribute name="format">1</xsl:attribute>
                        </xsl:if>
                    </xsl:if>

                    <!-- Multivolume output in AntennaHouse Formatter -->
                    <xsl:if test="$formatter='ah'">
                        <xsl:attribute name="axf:output-volume-break">true</xsl:attribute>
                    </xsl:if>
                    
                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>

                    <fo:flow flow-name="xsl-region-body">
                        
                        <xsl:apply-templates select="book-part-meta" mode="#current"/>
                        
                        <!-- Implement possible contents on part starter page -->
                        
                        <!-- [...] -->
                        
                    </fo:flow>
                </fo:page-sequence>
                
                <!-- Select subsequent content or book parts -->
                <xsl:apply-templates select="front-matter | body | book-app" mode="#current"/>
                
            </xsl:when>
            
            <!-- Chapters and appendices -->
            <xsl:otherwise>
                
                <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
                    <xsl:if test="not(preceding-sibling::book-part) and not(ancestor::book-part) and not(ancestor::book-back)">
                        <xsl:if test="(/book/@book-type='monograph' and $_front-matterMonographPagination!='1') or (/book/@book-type='proceedings' and $_front-matterProceedingsPagination!='1') or (not(/book/@book-type)) or (/book/@book-type!='monograph' and /book/@book-type!='proceedings')">
                            <xsl:attribute name="initial-page-number">1</xsl:attribute>
                            <xsl:attribute name="format">1</xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="$formatter='ah'">
                        <xsl:attribute name="axf:output-volume-break">true</xsl:attribute>
                    </xsl:if>
                    
                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <!-- Footnote separator line -->
                    <xsl:call-template name="footnote_separator_line"/>
                    
                    <!-- Static content -->
                    <xsl:call-template name="static_content"/>
                    
                    <!-- Text flow -->
                    <fo:flow flow-name="xsl-region-body">
                        
                        <!-- Chapter level section title block -->
                        <xsl:apply-templates select="book-part-meta" mode="#current"/>

                        <!-- Front matter -->
                        <xsl:apply-templates select="front-matter" mode="#current"/>

                        <!-- Chapter level section body -->
                        <xsl:apply-templates select="body" mode="#current"/>
                        
                        <!-- Chapter level section backmatter -->
                        <xsl:apply-templates select="back" mode="#current"/>
                        
                    </fo:flow>
                    
                </fo:page-sequence>
                
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>
    
    <!-- List of bibliographic references for a document or document component -->
    <xsl:template match="ref-list" mode="typesetting">
        
        <xsl:choose>
            <xsl:when test="parent::book-app-group or parent::book-back or parent::book-part-wrapper or parent::front-matter[parent::book] or parent::front-matter[parent::book-part[@book-part-type='part']]">
                
            <!-- <xsl:when test="not(ancestor::abstract) and not(ancestor::ack) and not(ancestor::back) and not(ancestor::bio) and not(ancestor::boxed-text) and not(ancestor::explanation) and not(ancestor::notes) and not(ancestor::option) and not(ancestor::question) and not(ancestor::ref-list) and not(ancestor::sec) and not(ancestor::trans-abstract)"> -->

                <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
                    <xsl:call-template name="page_number"/>

                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <!-- Footnote separator line -->
                    <xsl:call-template name="footnote_separator_line"/>
                    
                    <!-- Footers -->
                    
                    <!-- First odd page -->
                    <fo:static-content flow-name="page_template_first_odd_footer">
                        <xsl:call-template name="static_footer_first_odd_page"/>
                    </fo:static-content>
                    
                    <!-- First even page -->
                    <fo:static-content flow-name="page_template_first_even_footer">
                        <xsl:call-template name="static_footer_first_even_page"/>
                    </fo:static-content>
                    
                    <!-- Odd page -->
                    <fo:static-content flow-name="page_template_odd_footer">
                        <xsl:call-template name="static_footer_odd_page"/>
                    </fo:static-content>
                    
                    <!-- Even page -->
                    <fo:static-content flow-name="page_template_even_footer">
                        <xsl:call-template name="static_footer_even_page"/>
                    </fo:static-content>
                    
                    <!-- Headers -->
                    
                    <!-- Odd page -->
                    <fo:static-content flow-name="page_template_odd_header">
                        <xsl:call-template name="static_header_odd_page"/>
                    </fo:static-content>
                    
                    <!-- Even page -->
                    <fo:static-content flow-name="page_template_even_header">
                        <xsl:call-template name="static_header_even_page"/>
                    </fo:static-content>
                    
                    <!-- Text flow -->
                    
                    <fo:flow flow-name="xsl-region-body">
                                                
                        <!-- Title block -->
                        <xsl:call-template name="chapter-heading"/>
                        
                        <!-- Body -->
                        <xsl:apply-templates select="node() except label except title" mode="#current"/>
                        
                    </fo:flow>
                    
                </fo:page-sequence>
                
            </xsl:when>
            <xsl:otherwise>
                
                <!-- Heading -->
                <xsl:if test="label or title">
                    <xsl:call-template name="section-heading"/>
                </xsl:if>
                
                <!-- Body -->                
                <xsl:apply-templates select="node() except label except title" mode="#current"/>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Endnotes in book back matter -->
    <xsl:template match="fn-group" mode="typesetting">
        <xsl:if test="$_footnote_handling='book-back-matter' and parent::book-back">
            <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
                <xsl:if test="$formatter='ah'">
                    <xsl:attribute name="axf:output-volume-break">true</xsl:attribute>
                </xsl:if>
            
                <!-- Insert ID for internal referencing -->
                <xsl:if test="@id">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                </xsl:if>
                
                <!-- Footnote separator line -->
                <xsl:call-template name="footnote_separator_line"/>
                
                <!-- Footers -->
                
                <!-- First odd page -->
                <fo:static-content flow-name="page_template_first_odd_footer">
                    <xsl:call-template name="static_footer_first_odd_page"/>
                </fo:static-content>
                
                <!-- First even page -->
                <fo:static-content flow-name="page_template_first_even_footer">
                    <xsl:call-template name="static_footer_first_even_page"/>
                </fo:static-content>
                
                <!-- Odd page -->
                <fo:static-content flow-name="page_template_odd_footer">
                    <xsl:call-template name="static_footer_odd_page"/>
                </fo:static-content>
                
                <!-- Even page -->
                <fo:static-content flow-name="page_template_even_footer">
                    <xsl:call-template name="static_footer_even_page"/>
                </fo:static-content>
                
                <!-- Headers -->
                
                <!-- Odd page -->
                <fo:static-content flow-name="page_template_odd_header">
                    <xsl:call-template name="static_header_odd_page"/>
                </fo:static-content>
                
                <!-- Even page -->
                <fo:static-content flow-name="page_template_even_header">
                    <xsl:call-template name="static_header_even_page"/>
                </fo:static-content>
                
                <!-- Text flow -->
                <fo:flow flow-name="xsl-region-body">
 
                    <!-- Title block -->
                    <xsl:call-template name="chapter-heading"/>
                    
                    <!-- Body -->
                    <xsl:for-each select="/descendant::xref[@ref-type='fn']">
                        <xsl:variable name="_fn_id" select="@rid"/>
                        <fo:block>
                            <xsl:apply-templates select="/descendant::fn[@id = $_fn_id]" mode="#current"/>
                        </fo:block>
                    </xsl:for-each>
                    
                </fo:flow>
            
            </fo:page-sequence>
            
        </xsl:if>
    </xsl:template>
    
    <!-- * Common structures *************************************** -->

    <xsl:template match="book-part-meta" mode="typesetting">
        <xsl:apply-templates select="title-group" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="title-group" mode="typesetting">
        
        <xsl:variable name="_hierarchy_counter">
            <xsl:value-of select="count(ancestor-or-self::ack)
                + count(ancestor-or-self::app)
                + count(ancestor-or-self::app-group)
                + count(ancestor-or-self::bio)
                + count(ancestor-or-self::book-part[@book-part-type='chapter'])
                + count(ancestor-or-self::book-part[not(@book-part-type)])
                + count(ancestor-or-self::def-list)
                + count(ancestor-or-self::foreword)
                + count(ancestor-or-self::front-matter-part)
                + count(ancestor-or-self::glossary)
                + count(ancestor-or-self::notes)
                + count(ancestor-or-self::preface)
                + count(ancestor-or-self::ref-list)
                + count(ancestor-or-self::sec)
                - 2"/>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="parent::book-part-meta[parent::book-part[@book-part-type='part']] or
                parent::book-part-meta[parent::book-app-group]">
                <xsl:call-template name="part-heading"/>
            </xsl:when>
            <xsl:when test="$_hierarchy_counter &lt; 0 and (parent::book-part-meta[parent::book-part[@book-part-type='chapter']] or 
                parent::book-part-meta[parent::book-part[not(@book-part-type)]] or
                parent::book-part-meta[parent::book-app] or
                parent::book-part-meta[parent::dedication] or
                parent::book-part-meta[parent::foreword] or
                parent::book-part-meta[parent::preface] or
                parent::book-part-meta[parent::front-matter-part])">
                <xsl:call-template name="chapter-heading"/>
            </xsl:when>
            <xsl:when test="$_hierarchy_counter &gt;= 0">
                <xsl:call-template name="section-heading"/>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="body | named-book-part-body" mode="typesetting">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <xsl:template match="back" mode="typesetting">
        
        <xsl:apply-templates select="ack | bio | app | app-group | dedication | glossary | notes" mode="#current"/>
            
        <!-- Endnotes in chapter back matter -->
        <xsl:if test="$_footnote_handling='chapter-back-matter' and descendant::xref[@ref-type='fn']">
            <xsl:element name="fo:block" use-attribute-sets="section_heading_1">
                <xsl:choose>
                    <xsl:when test="$_localization/localization-group[@name='endnotes']/localization-item[@xml:lang=$_bookLanguage]">
                        <xsl:value-of select="$_localization/localization-group[@name='endnotes']/localization-item[@xml:lang=$_bookLanguage]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Endnotes</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:for-each select="descendant::xref[@ref-type='fn']">
                <xsl:variable name="_fn_id" select="@rid"/>
                <fo:block>
                    <xsl:apply-templates select="/descendant::fn[@id = $_fn_id]" mode="#current"/>
                </fo:block>
            </xsl:for-each>
        </xsl:if>

        <xsl:apply-templates select="ref-list" mode="#current"/>
        
    </xsl:template>

    <xsl:template match="sec" mode="typesetting">
        <xsl:call-template name="section-heading"/>
        <xsl:apply-templates select="node() except label except title except subtitle" mode="#current"/>
    </xsl:template>

    <!-- * Formats ************************************************* -->

    <!-- Headings
            1. Part headings and subsequent sub part headings
            2. Chapter headings
            3. Section headings
            4. No headings (where headings are optional) -->

    <xsl:template name="part-heading">
        
        <xsl:element name="fo:block-container">
            
            <!-- Author name(s) -->
            <!-- […] -->
            
            <!-- Title block (label, title and subtitle) -->
            
            <!-- Label as separate paragraph -->
            <xsl:if test="$_part_label_formatting='paragraph' and label">
                <xsl:element name="fo:block" use-attribute-sets="part_label">
                    <xsl:apply-templates select="label" mode="typesetting"/>
                </xsl:element>
            </xsl:if>

            <!-- To do: Part title and label as hanging paragraphs -->
            
            <!-- Inline label -->
            <xsl:if test="title or ($_part_label_formatting='inline' and label)">
                <xsl:element name="fo:block" use-attribute-sets="part_heading">
                    <xsl:if test="$_part_label_formatting='inline' and label">
                        <xsl:apply-templates select="label" mode="typesetting"/><xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="title" mode="typesetting"/>
                </xsl:element>            
            </xsl:if>
            
            <!-- Subtitle -->
            <xsl:if test="subtitle">
                <xsl:element name="fo:block" use-attribute-sets="part_subheading">
                    <xsl:apply-templates select="subtitle" mode="typesetting"/>
                </xsl:element>
            </xsl:if>
            
        </xsl:element>                
        
    </xsl:template>

    <xsl:template name="chapter-heading">
        
        <xsl:variable name="_chapter_language" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
        
        <xsl:variable name="_hierarchy_counter">
            <xsl:value-of select="count(ancestor-or-self::ack)
                + count(ancestor-or-self::app)
                + count(ancestor-or-self::app-group)
                + count(ancestor-or-self::bio)
                + count(ancestor-or-self::book-part[@book-part-type='chapter'])
                + count(ancestor-or-self::book-part[not(@book-part-type)])
                + count(ancestor-or-self::def-list)
                + count(ancestor-or-self::foreword)
                + count(ancestor-or-self::front-matter-part)
                + count(ancestor-or-self::glossary)
                + count(ancestor-or-self::notes)
                + count(ancestor-or-self::preface)
                + count(ancestor-or-self::ref-list)
                + count(ancestor-or-self::sec)
                - 2"/>
        </xsl:variable>
        
        <xsl:choose>
            
            <!-- Within e.g. a chapter, some book division appear as a section -->
            <xsl:when test="$_hierarchy_counter &gt;= 0">
                <xsl:call-template name="section-heading"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:element name="fo:block-container" use-attribute-sets="chapter_title_margins">

                    <!-- Marker for running titles -->
                    
                    <fo:marker marker-class-name="chapter-title">
                        <xsl:if test="label">
                            <xsl:value-of select="label"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="alt-title">
                                <xsl:apply-templates select="alt-title" mode="#current"/>
                            </xsl:when>
                            <xsl:when test="title">
                                <xsl:apply-templates select="title" mode="#current"/>
                            </xsl:when>
                        </xsl:choose>
                    </fo:marker>
                    
                    <fo:marker marker-class-name="heading-1">
                        <xsl:if test="label">
                            <xsl:value-of select="label"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="alt-title">
                                <xsl:apply-templates select="alt-title" mode="#current"/>
                            </xsl:when>
                            <xsl:when test="title">
                                <xsl:apply-templates select="title" mode="#current"/>
                            </xsl:when>
                        </xsl:choose>
                    </fo:marker>
                    
                    <fo:marker marker-class-name="authors">
                        <xsl:choose>
                            <xsl:when test="../contrib-group/contrib[@contrib-type='aut'] and count(../contrib-group/contrib[@contrib-type='aut']) &lt; 4">
                                <xsl:for-each select="../contrib-group/contrib[@contrib-type='aut']">
                                    <xsl:if test="position() > 1 and not(position() = last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="position() > 1 and position() = last()">
                                        <xsl:text> </xsl:text><xsl:value-of select="$_localization/localization-group[@name='and']/localization-item[@xml:lang=$_chapter_language]"/><xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="name/given-names"/><xsl:text> </xsl:text><xsl:value-of select="name/surname"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="../contrib-group/contrib[@contrib-type='aut'] and count(../contrib-group/contrib[@contrib-type='aut']) &gt; 4">
                                <xsl:for-each select="../contrib-group/contrib[@contrib-type='aut']">
                                    <xsl:if test="position() = 1">
                                        <xsl:value-of select="name/given-names"/><xsl:text> </xsl:text><xsl:value-of select="name/surname"/><xsl:text> </xsl:text><xsl:value-of select="$_localization/localization-group[@name='et_al']/localization-item[@xml:lang=$_chapter_language]"/>                               
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="sec-meta/contrib-group/contrib[@contrib-type='aut'] and count(sec-meta/contrib-group/contrib[@contrib-type='aut']) &lt; 4">
                                <xsl:for-each select="sec-meta/contrib-group/contrib[@contrib-type='aut']">
                                    <xsl:if test="position() > 1 and not(position() = last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="position() > 1 and position() = last()">
                                        <xsl:text> </xsl:text><xsl:value-of select="$_localization/localization-group[@name='and']/localization-item[@xml:lang=$_chapter_language]"/><xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="name/given-names"/><xsl:text> </xsl:text><xsl:value-of select="name/surname"/>
                                </xsl:for-each>                                
                            </xsl:when>
                            <xsl:when test="sec-meta/contrib-group/contrib[@contrib-type='aut'] and count(sec-meta/contrib-group/contrib[@contrib-type='aut']) &gt; 4">
                                <xsl:for-each select="sec-meta/contrib-group/contrib[@contrib-type='aut']">
                                    <xsl:if test="position() = 1">
                                        <xsl:value-of select="name/given-names"/><xsl:text> </xsl:text><xsl:value-of select="name/surname"/><xsl:text> </xsl:text><xsl:value-of select="$_localization/localization-group[@name='et_al']/localization-item[@xml:lang=$_chapter_language]"/>                               
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="label">
                                    <xsl:value-of select="label"/>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="alt-title">
                                        <xsl:apply-templates select="alt-title" mode="#current"/>
                                    </xsl:when>
                                    <xsl:when test="title">
                                        <xsl:apply-templates select="title" mode="#current"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:marker>
                    
                    <!-- Formatting -->
                    
                    <!-- Author name(s) -->
                    <!-- […] -->
                    
                    <!-- Title block (label, title and subtitle) -->

                    <!-- Label as paragraph -->
                    <xsl:if test="$_chapter_label_formatting='paragraph' and label">
                        <xsl:element name="fo:block" use-attribute-sets="chapter_label">
                            <xsl:apply-templates select="label" mode="typesetting"/>
                        </xsl:element>
                    </xsl:if>
                    
                    <!-- Inline label and heading -->
                    <xsl:if test="title or ($_chapter_label_formatting='inline' and label)">
                        
                        <xsl:choose>
                            
                            <!-- Inline formatting of label and title, subtitle -->
                            <xsl:when test="$_chapter_label_formatting='inline' and label">
                                <fo:table>
                                    <fo:table-body>
                                        <!-- Label and heading -->
                                        <fo:table-row>
                                            <fo:table-cell>
                                                <xsl:element name="fo:block" use-attribute-sets="chapter_heading">
                                                    <xsl:if test="$_chapter_label_formatting='inline' and label">
                                                        <xsl:apply-templates select="label" mode="typesetting"/><xsl:text>&#160;&#160;</xsl:text>
                                                    </xsl:if>
                                                </xsl:element>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <xsl:element name="fo:block" use-attribute-sets="chapter_heading">
                                                    <xsl:apply-templates select="title" mode="typesetting"/>
                                                </xsl:element>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:when>
                            
                            <!-- Title w/o label -->
                            <xsl:otherwise>
                                <xsl:element name="fo:block" use-attribute-sets="chapter_heading">
                                    <xsl:apply-templates select="title" mode="typesetting"/>
                                </xsl:element>
                            </xsl:otherwise>
                            
                        </xsl:choose>
                        
                    </xsl:if>
                    
                    <!-- Subtitle -->
                    <xsl:if test="subtitle">
                        <xsl:element name="fo:block" use-attribute-sets="chapter_subheading">
                            <xsl:apply-templates select="subtitle" mode="typesetting"/>
                        </xsl:element>
                    </xsl:if>
                    
                </xsl:element>
            </xsl:otherwise>
            
        </xsl:choose>

    </xsl:template>
    
    <xsl:template name="section-heading">
        
        <xsl:variable name="_hierarchy_counter">
            <xsl:value-of select="count(ancestor-or-self::ack)
                + count(ancestor-or-self::app)
                + count(ancestor-or-self::app-group)
                + count(ancestor-or-self::bio)
                + count(ancestor-or-self::book-part[@book-part-type='chapter'])
                + count(ancestor-or-self::book-part[not(@book-part-type)])
                + count(ancestor-or-self::def-list)
                + count(ancestor-or-self::foreword)
                + count(ancestor-or-self::front-matter-part)
                + count(ancestor-or-self::glossary)
                + count(ancestor-or-self::notes)
                + count(ancestor-or-self::preface)
                + count(ancestor-or-self::ref-list)
                + count(ancestor-or-self::sec)
                - 2"/>
        </xsl:variable>
                
        <xsl:choose>
            <xsl:when test="$_hierarchy_counter = 0">
                <xsl:element name="fo:block" use-attribute-sets="section_heading_1">
                    <xsl:call-template name="section_heading_formatting"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$_hierarchy_counter = 1">
                <xsl:element name="fo:block" use-attribute-sets="section_heading_2">
                    <xsl:call-template name="section_heading_formatting"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$_hierarchy_counter = 2">
                <xsl:element name="fo:block" use-attribute-sets="section_heading_3">
                    <xsl:call-template name="section_heading_formatting"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$_hierarchy_counter > 2">
                <xsl:element name="fo:block" use-attribute-sets="section_heading_4">
                    <xsl:call-template name="section_heading_formatting"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>

    </xsl:template>
    
    <xsl:template name="section_heading_formatting">
        
        <xsl:choose>
            <xsl:when test="parent::book-part-meta">
                <xsl:if test="../../@id">
                    <xsl:attribute name="id">
                        <xsl:value-of select="../../@id"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@id">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- Marker for running titles -->
        
        <xsl:variable name="_hierarchy_counter">
            <xsl:value-of select="count(ancestor-or-self::ack)
                + count(ancestor-or-self::app)
                + count(ancestor-or-self::app-group)
                + count(ancestor-or-self::bio)
                + count(ancestor-or-self::book-part[@book-part-type='chapter'])
                + count(ancestor-or-self::book-part[not(@book-part-type)])
                + count(ancestor-or-self::def-list)
                + count(ancestor-or-self::foreword)
                + count(ancestor-or-self::front-matter-part)
                + count(ancestor-or-self::glossary)
                + count(ancestor-or-self::notes)
                + count(ancestor-or-self::preface)
                + count(ancestor-or-self::ref-list)
                + count(ancestor-or-self::sec)
                - 2"/>
        </xsl:variable>
        
        <xsl:if test="$_hierarchy_counter = 0">
            <fo:marker marker-class-name="heading-1">
                <xsl:if test="label">
                    <xsl:value-of select="label"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="alt-title">
                        <xsl:apply-templates select="alt-title" mode="#current"/>
                    </xsl:when>
                    <xsl:when test="title">
                        <xsl:apply-templates select="title" mode="#current"/>
                    </xsl:when>
                </xsl:choose>
            </fo:marker>
        </xsl:if>
        
        <!-- Formatting -->
        
        <xsl:choose>
            <xsl:when test="label">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block>
                                    <xsl:if test="label">
                                        <xsl:apply-templates select="label" mode="typesetting"/>
                                        <xsl:text>&#160;&#160;</xsl:text>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block>
                                    <xsl:if test="title">
                                        <xsl:apply-templates select="title" mode="typesetting"/>
                                    </xsl:if>
                                    <xsl:if test="subtitle">
                                        <xsl:text>. </xsl:text>
                                        <xsl:apply-templates select="subtitle" mode="typesetting"/>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="title">
                    <xsl:apply-templates select="title" mode="typesetting"/>
                </xsl:if>
                <xsl:if test="subtitle">
                    <xsl:text>. </xsl:text>
                    <xsl:apply-templates select="subtitle" mode="typesetting"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
    <xsl:template match="label | title | subtitle" mode="typesetting">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <!-- Definition lists -->

    <xsl:template match="def-list" mode="typesetting">
        
        <!-- Heading -->
        <xsl:if test="label or title">
            <xsl:call-template name="section-heading"/>
        </xsl:if>
        
        <xsl:choose>
            
            <!-- Lexicon styled definition lists -->
            <xsl:when test="@list-type='lexicon'">
                
                <xsl:element name="fo:block-container">
                    <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    <xsl:if test="not(ancestor::def-list[@list-type='lexicon'])">
                        <xsl:attribute name="column-count" select="$_columnsLexicon"/>
                        <xsl:attribute name="column-gap" select="$_columnGap"/>
                    </xsl:if>

                    <xsl:if test="term-head or def-head">
                        <fo:block>
                            <xsl:call-template name="language_attribute"/>
                            <xsl:apply-templates select="term-head" mode="#current"/><xsl:text> </xsl:text><xsl:apply-templates select="def-head" mode="#current"/>
                        </fo:block>
                    </xsl:if>
                    
                    <xsl:apply-templates select="def-list | def-item" mode="#current"/>
                    
                </xsl:element>
                
            </xsl:when>
            
            <!-- Definition lists in table style -->
            <xsl:otherwise>

                <fo:block>
                    <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    
                    <fo:table width="100%">
                        <xsl:if test="not(label) and not(title) and @id">
                            <xsl:attribute name="id" select="@id"/>
                        </xsl:if>
                        
                        <fo:table-column column-width="30%"/>
                        <fo:table-column column-width="70%"/>
                        
                        <xsl:if test="term-head or def-head">
                            
                            <fo:table-header>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:apply-templates select="term-head" mode="#current"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:apply-templates select="def-head" mode="#current"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                        </xsl:if>
                        
                        <!-- Abfangen: def-list kann wiederum def-lists beinhalten! Hier wird das aber ignoriert -->
                        
                        <fo:table-body>
                            <xsl:apply-templates select="def-item" mode="#current"/>
                        </fo:table-body>
                        
                    </fo:table>
                    
                </fo:block>
                
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="def-item" mode="typesetting">

        <xsl:choose>
            
            <!-- Lexicon styled definition lists -->
            <xsl:when test="ancestor::def-list[1][@list-type='lexicon']">
                <xsl:element name="fo:block" use-attribute-sets="lexicon_first_paragraph_style">
                    <xsl:call-template name="language_attribute"/>
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <xsl:apply-templates select="term" mode="#current"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="def" mode="#current"/>
                </xsl:element>
            </xsl:when>
            
            <!-- Definition lists in table style -->
            <xsl:otherwise>
                <fo:table-row>
                    <fo:table-cell padding-right="1mm">
                        <xsl:apply-templates select="term" mode="#current"/>
                    </fo:table-cell>
                    <fo:table-cell padding-left="1mm">
                        <xsl:apply-templates select="def" mode="#current"/>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <!-- Block level elements like block quotes or text boxes -->
    
    <!-- [...] -->

    <!-- Paragraphs -->

    <xsl:template match="p" mode="typesetting">
        <xsl:choose>
            <!-- Footnote paragraphs -->
            <xsl:when test="ancestor::fn">
                <xsl:variable name="_fn_id" select="ancestor::fn/@id"/>
                <xsl:choose>
                    <xsl:when test="not(./preceding-sibling::p)">
                        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_petit paragraph_footnote_first hyphenate">
                            <xsl:call-template name="language_attribute"/>
                            <xsl:choose>
                                <xsl:when test="$medium='interactive' and $_footnote_crossref='yes'">
                                    <xsl:element name="fo:inline" use-attribute-sets="hyperlink">
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="ancestor::fn/@id "/>
                                        </xsl:attribute>
                                        <xsl:variable name="backlink">
                                            <xsl:value-of select="$_fn_id"/>
                                            <xsl:text>_backlink</xsl:text>
                                        </xsl:variable>
                                        <fo:basic-link internal-destination="{$backlink}">
                                            <xsl:value-of select="/descendant::xref[@rid = $_fn_id and @ref-type='fn']"/>
                                        </fo:basic-link>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <fo:inline><xsl:value-of select="/descendant::xref[@rid = $_fn_id and @ref-type='fn']"/></fo:inline>                                    
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>&#x00A0;</xsl:text><xsl:apply-templates mode="#current"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_petit paragraph_footnote_subsequent hyphenate">
                            <xsl:call-template name="language_attribute"/>
                            <xsl:apply-templates mode="#current"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Dedication -->
            <xsl:when test="ancestor::dedication">
                <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_dedication do_not_hyphenate">
                    <xsl:call-template name="language_attribute"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <!-- Epigraph -->
            <xsl:when test="ancestor::front-matter-part[@book-part-type='epigraph']">
                <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_epigraph do_not_hyphenate">
                    <xsl:call-template name="language_attribute"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <!-- Paragraphs in a lexicon section -->
            <xsl:when test="ancestor::def-list[1][@list-type='lexicon']">
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::*) = 0">
                        <xsl:apply-templates mode="#current"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block" use-attribute-sets="lexicon_paragraph_style">
                            <xsl:call-template name="language_attribute"/>
                            <xsl:apply-templates mode="#current"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Paragraphs in a table body -->
            <xsl:when test="ancestor::td">
                <xsl:call-template name="table_body_cell"/>
            </xsl:when>
            <!-- Paragraphs in a table head -->
            <xsl:when test="ancestor::th">
                <xsl:call-template name="table_head_cell"/>
            </xsl:when>
            <!-- Caption -->
            <xsl:when test="parent::caption">
                <xsl:element name="fo:block" use-attribute-sets="caption"> 
                    <xsl:if test="not(preceding-sibling::*[1][self::p])">
                        <xsl:if test="(../../label) and ($_caption_label_formatting='inline')">
                            <xsl:element name="fo:inline" use-attribute-sets="caption-label-inline">
                                <xsl:apply-templates select="../../label" mode="#current"/><xsl:text>. </xsl:text>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <!-- Epigraphs and dedications in sections -->
            <xsl:when test="@content-type='epigraph'">
                <xsl:element name="fo:block" use-attribute-sets="paragraph_epigraph_section">
                    <xsl:if test="not(preceding-sibling::p[@content-type='epigraph'])">
                        <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    </xsl:if>
                    <xsl:if test="not(following-sibling::p[@content-type='epigraph'])">
                        <xsl:attribute name="space-after" select="$_regularLineHeight"/>                        
                    </xsl:if>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@content-type='dedication'">
                <xsl:element name="fo:block" use-attribute-sets="paragraph_epigraph_section">
                    <xsl:if test="not(preceding-sibling::p[@content-type='dedication'])">
                        <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    </xsl:if>
                    <xsl:if test="not(following-sibling::p[@content-type='dedication'])">
                        <xsl:attribute name="space-after" select="$_regularLineHeight"/>                        
                    </xsl:if>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <!-- Regular paragraphs -->
            <xsl:when test="(preceding-sibling::*[1][self::p] or preceding-sibling::*[@position='float']) and not(preceding-sibling::p[@content-type='epigraph'])">
                <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_indent hyphenate">

                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>

                    <!-- Language -->
                    <xsl:call-template name="language_attribute"/>

                    <!-- Content -->
                    <xsl:apply-templates mode="#current"/>
                    
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_no_indent hyphenate">

                    <!-- Insert a blank line when a paragraph follows a def list directly -->
                    <xsl:if test="preceding-sibling::*[1][self::def-list]">
                        <xsl:attribute name="space-before">
                            <xsl:value-of select="$_regularLineHeight"/>
                        </xsl:attribute>
                    </xsl:if>

                    <!-- Insert ID for internal referencing -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <!-- Language -->
                    <xsl:call-template name="language_attribute"/>

                    <!-- Content -->
                    <xsl:apply-templates mode="#current"/>

                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="table_body_cell">
        <xsl:element name="fo:block" use-attribute-sets="table_body_paragraph_style">
            <xsl:call-template name="language_attribute"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="table_head_cell">
        <xsl:element name="fo:block" use-attribute-sets="table_head_paragraph_style">
            <xsl:call-template name="language_attribute"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="term" mode="typesetting">
        
        <xsl:choose>
            <!-- Inline term -->
            <xsl:when test="ancestor::def-list[1][@list-type='lexicon']">
                <xsl:element name="fo:inline" use-attribute-sets="lexicon-lemma">
                    <xsl:call-template name="language_attribute"/>
                    <xsl:apply-templates mode="#current"/>                    
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_no_indent hyphenate">
                    <xsl:call-template name="language_attribute"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="mixed-citation" mode="typesetting">
        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_petit hyphenate paragraph_bib_entry">
            <!-- ID -->
            <xsl:if test="../@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="../@id"/>
                </xsl:attribute>
            </xsl:if>
            
            <!-- Language -->
            <xsl:call-template name="language_attribute"/>
            
            <xsl:if test="../preceding-sibling::*[1][self::title] or ../preceding-sibling::*[1][self::label] or ../preceding-sibling::*[1][self::p]">
                <xsl:attribute name="space-before">
                    <xsl:value-of select="$_regularLineHeight"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <!-- Tables -->
    
    <xsl:template match="table-wrap-group" mode="typesetting">
        <xsl:element name="fo:block-container">
            <xsl:attribute name="space-before" select="$_regularLineHeight"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table-wrap" mode="typesetting">
        <xsl:choose>
            <xsl:when test="not(@position) or @position='float'">
                <xsl:element name="fo:float">
                    <xsl:attribute name="float">before</xsl:attribute>
                    <xsl:attribute name="axf:float-margin-y">
                        <xsl:value-of select="$_regularLineHeight"/>
                    </xsl:attribute>
                    <xsl:call-template name="table"/>                    
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="table"/>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="table">
        <xsl:element name="fo:block-container">
            <xsl:attribute name="space-before" select="$_regularLineHeight"/>
            <xsl:attribute name="space-after" select="$_regularLineHeight"/>
            <xsl:if test="@orientation='landscape'">
                <xsl:attribute name="reference-orientation">90</xsl:attribute>
            </xsl:if>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:element name="fo:table-and-caption">
                <!-- Caption -->
                <xsl:if test="label or caption">
                    <xsl:element name="fo:table-caption">
                        <xsl:call-template name="label-and-caption"/>
                    </xsl:element>
                </xsl:if>
                <!-- Table -->
                <xsl:apply-templates select="* except label except caption" mode="#current"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="table" mode="typesetting">
        <xsl:element name="fo:table" use-attribute-sets="table_style">
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="thead" mode="typesetting">
        <xsl:element name="fo:table-header" use-attribute-sets="table_style_head">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tbody" mode="typesetting">
        <xsl:element name="fo:table-body" use-attribute-sets="table_style_body">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tfoot" mode="typesetting">
        <xsl:element name="fo:table-footer" use-attribute-sets="table_style_body">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tr" mode="typesetting">
        <xsl:choose>
            <xsl:when test="parent::thead">
                <xsl:element name="fo:table-row" use-attribute-sets="table_style_head_row">
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates mode="#current"/>                    
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:table-row" use-attribute-sets="table_style_head_row">
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates mode="#current"/>                    
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="td | th" mode="typesetting">
        <xsl:choose>
            <xsl:when test="ancestor::thead">
                <xsl:element name="fo:table-cell" use-attribute-sets="table_style_head_cell">
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="number-columns-spanned">
                        <xsl:value-of select="@colspan"/>
                    </xsl:attribute>
                    <xsl:attribute name="number-rows-spanned">
                        <xsl:value-of select="@rowspan"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="not(descendant::p)">
                            <xsl:choose>
                                <xsl:when test="self::th">
                                    <xsl:call-template name="table_head_cell"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="table_body_cell"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="#current"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:table-cell" use-attribute-sets="table_style_body_cell">
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="number-columns-spanned">
                        <xsl:value-of select="@colspan"/>
                    </xsl:attribute>
                    <xsl:attribute name="number-rows-spanned">
                        <xsl:value-of select="@rowspan"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="not(descendant::p)">
                            <xsl:choose>
                                <xsl:when test="self::th">
                                    <xsl:call-template name="table_head_cell"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="table_body_cell"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="#current"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Label and caption -->

    <xsl:template name="label-and-caption">
        <xsl:choose>
            <xsl:when test="$_caption_label_formatting='inline'">
                <xsl:if test="not(caption)">
                    <xsl:element name="fo:block" use-attribute-sets="caption">
                        <xsl:element name="fo:inline">
                            <xsl:apply-templates select="label" mode="#current"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="caption">
                    <xsl:apply-templates select="caption" mode="#current"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="label">
                    <xsl:element name="fo:block" use-attribute-sets="caption-label">
                        <xsl:apply-templates select="label" mode="#current"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="caption">
                    <xsl:element name="fo:block" use-attribute-sets="caption">
                        <xsl:apply-templates select="caption" mode="#current"/>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Formulae -->
    
    <xsl:template match="disp-formula-group" mode="typesetting">
        <xsl:element name="fo:block-container">
            <xsl:attribute name="space-before" select="$_regularLineHeight"/>
            <xsl:attribute name="space-after" select="$_regularLineHeight"/>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="label-and-caption"/>
            <xsl:apply-templates select="* except label except caption" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="disp-formula" mode="typesetting">
        <xsl:choose>
            <xsl:when test="label and not(caption)">
                <fo:table width="100%">
                    <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    <xsl:attribute name="space-after" select="$_regularLineHeight"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block text-align="center">
                                    <xsl:apply-templates select="* except label" mode="#current"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell width="1cm" display-align="center" text-align="right">
                                <fo:block>
                                    <xsl:apply-templates select="label" mode="#current"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:when test="not(label) and not(caption)">
                <fo:block text-align="center">
                    <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    <xsl:attribute name="space-after" select="$_regularLineHeight"/>
                    <xsl:apply-templates mode="#current"/>
                </fo:block>                
            </xsl:when>
            <xsl:when test="caption">
                <xsl:call-template name="label-and-caption"/>
                <fo:block text-align="center">
                    <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                    <xsl:attribute name="space-after" select="$_regularLineHeight"/>
                    <xsl:apply-templates select="* except label except caption" mode="#current"/>
                </fo:block>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="inline-formula" mode="typesetting">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <xsl:template match="mml:math" mode="typesetting">
        <fo:instream-foreign-object>
            <xsl:copy-of select="."/>
        </fo:instream-foreign-object>        
    </xsl:template>
    
    <!-- Inline elements -->

    <xsl:template match="bold" mode="typesetting">
        <fo:inline font-weight="bold">
            <xsl:apply-templates mode="#current"/>
        </fo:inline>  
    </xsl:template>

    <xsl:template match="italic" mode="typesetting">
        <fo:inline font-style="italic">
            <xsl:apply-templates mode="#current"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="sc" mode="typesetting">
        <fo:inline font-variant="small-caps">
            <xsl:apply-templates mode="#current"/>
        </fo:inline>
    </xsl:template>
    
    <xsl:template match="sup" mode="typesetting">
        <xsl:element name="fo:inline" use-attribute-sets="superscript">
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template> 

    <xsl:template match="sub" mode="typesetting">
        <xsl:element name="fo:inline" use-attribute-sets="subscript">
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template> 
    
    <xsl:template match="xref" mode="typesetting">
        <xsl:choose>
            <!-- Footnotes -->
            <xsl:when test="@ref-type='fn'">
                <xsl:variable name="_fn_id" select="@rid"/>
                <xsl:choose>
                    <xsl:when test="$_footnote_handling='footnotes' or ancestor::dedication or ancestor::front-matter-part[@book-part-type='epigraph']">
                        <fo:footnote>
                            <xsl:call-template name="footnote_reference_number_in_text_flow"/>
                            <xsl:if test="$_footnote_handling != 'book-back-matter'">
                                <fo:footnote-body>
                                    <xsl:apply-templates select="/descendant::fn[@id = $_fn_id]" mode="#current"/>
                                </fo:footnote-body>
                            </xsl:if>
                        </fo:footnote>
                    </xsl:when>
                    <xsl:when test="($_footnote_handling='chapter-back-matter' or $_footnote_handling='book-back-matter') and (not(ancestor::dedication) and not(ancestor::front-matter-part[@book-part-type='epigraph']))">
                        <xsl:call-template name="footnote_reference_number_in_text_flow"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- Section, table or figure references -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$medium='interactive' and $_crossref='yes'">
                        <xsl:element name="fo:inline" use-attribute-sets="hyperlink">
                            <fo:basic-link internal-destination="{@rid}">
                                <xsl:apply-templates mode="#current"/>
                            </fo:basic-link>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ext-link" mode="typesetting">
        <xsl:choose>
            <xsl:when test="$_external_hyperlinks='yes'">
                <xsl:element name="fo:inline" use-attribute-sets="hyperlink do_not_hyphenate">
                    <fo:basic-link>
                        <xsl:attribute name="external-destination">
                            <xsl:value-of select="@xlink:href"/>
                        </xsl:attribute>
                        <xsl:apply-templates mode="#current"/>
                    </fo:basic-link>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="#current"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="footnote_reference_number_in_text_flow">
        <xsl:choose>
            <xsl:when test="$medium='interactive' and $_footnote_crossref='yes'">
                <xsl:element name="fo:inline" use-attribute-sets="superscript hyperlink">
                    <xsl:attribute name="id">
                        <xsl:variable name="backlink">
                            <xsl:value-of select="@rid"/>
                            <xsl:text>_backlink</xsl:text>
                        </xsl:variable>
                        <xsl:value-of select="$backlink"/>
                    </xsl:attribute>
                    <fo:basic-link internal-destination="{@rid}">
                        <xsl:apply-templates mode="#current"/>
                    </fo:basic-link>
                </xsl:element>                                    
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:inline" use-attribute-sets="superscript">
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Header and footer -->
    
    <xsl:template name="static_header_odd_page">
        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_header_odd_page do_not_hyphenate">
            <xsl:if test="$running_headers='yes'">
                
                <xsl:choose>
                    <xsl:when test="/book/@book-type='monograph'">
                        <fo:retrieve-marker retrieve-class-name="heading-1" retrieve-position="last-ending-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='proceedings'">
                        <fo:retrieve-marker retrieve-class-name="chapter-title" retrieve-position="first-including-carryover" retrieve-boundary="page-sequence"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='lexicon'">
                        <fo:retrieve-marker retrieve-class-name="lemma" retrieve-position="last-ending-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:retrieve-marker retrieve-class-name="heading-1" retrieve-position="last-ending-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:if>
            <xsl:if test="$page_number='header'">
                <xsl:if test="$running_headers='yes'"><xsl:text> – </xsl:text></xsl:if><fo:page-number/>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="static_header_even_page">
        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular paragraph_header_even_page do_not_hyphenate">
            <xsl:if test="$page_number">
                <fo:page-number/><xsl:if test="$running_headers='yes'"><xsl:text> – </xsl:text></xsl:if>
            </xsl:if>
            <xsl:if test="$running_headers='yes'">

                <xsl:choose>
                    <xsl:when test="/book/@book-type='monograph'">
                        <fo:retrieve-marker retrieve-class-name="chapter-title" retrieve-position="last-ending-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='proceedings'">
                        <fo:retrieve-marker retrieve-class-name="authors" retrieve-position="last-ending-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='lexicon'">
                        <fo:retrieve-marker retrieve-class-name="lemma" retrieve-position="first-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:retrieve-marker retrieve-class-name="heading-1" retrieve-position="first-within-page" retrieve-boundary="page-sequence"/>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="static_footer_first_odd_page">
        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular do_not_hyphenate">
            <xsl:attribute name="text-align">center</xsl:attribute>
            <fo:page-number/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="static_footer_first_even_page">
        <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular do_not_hyphenate">
            <xsl:attribute name="text-align">center</xsl:attribute>
            <fo:page-number/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="static_footer_odd_page">
        <xsl:if test="$page_number='footer'">
            <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular do_not_hyphenate">
                <xsl:attribute name="text-align">center</xsl:attribute>
                <fo:page-number/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="static_footer_even_page">
        <xsl:if test="$page_number='footer'">
            <xsl:element name="fo:block" use-attribute-sets="font_family_regular font_regular do_not_hyphenate">
                <xsl:attribute name="text-align">center</xsl:attribute>
                <fo:page-number/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="footnote_separator_line">
        <!-- Footnote separator -->
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block text-align-last="justify">
                <xsl:attribute name="margin-top">
                    <xsl:value-of select="$_regularLineHeight"/>
                </xsl:attribute>
                <xsl:if test="$_footnote_separator_line = 'yes'">
                    <xsl:element name="fo:leader" use-attribute-sets="footnote_separator_line_definition"/>
                </xsl:if>
            </fo:block>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="page_number">
        <xsl:if test="ancestor::front-matter[parent::book]">
            <xsl:attribute name="format">
                <xsl:choose>
                    <xsl:when test="/book/@book-type='monograph'">
                        <xsl:value-of select="$_front-matterMonographPagination"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='proceedings'">
                        <xsl:value-of select="$_front-matterProceedingsPagination"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>i</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$formatter='ah'">
            <xsl:attribute name="axf:output-volume-break">true</xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="static_content">
        
        <!-- Footers -->
        
        <!-- First odd page -->
        <fo:static-content flow-name="page_template_first_odd_footer">
            <xsl:call-template name="static_footer_first_odd_page"/>
        </fo:static-content>
        
        <!-- First even page -->
        <fo:static-content flow-name="page_template_first_even_footer">
            <xsl:call-template name="static_footer_first_even_page"/>
        </fo:static-content>
        
        <!-- Odd page -->
        <fo:static-content flow-name="page_template_odd_footer">
            <xsl:call-template name="static_footer_odd_page"/>
        </fo:static-content>
        
        <!-- Even page -->
        <fo:static-content flow-name="page_template_even_footer">
            <xsl:call-template name="static_footer_even_page"/>
        </fo:static-content>
        
        <!-- Headers -->
        
        <!-- Odd page -->
        <fo:static-content flow-name="page_template_odd_header">
            <xsl:call-template name="static_header_odd_page"/>
        </fo:static-content>
        
        <!-- Even page -->
        <fo:static-content flow-name="page_template_even_header">
            <xsl:call-template name="static_header_even_page"/>
        </fo:static-content>
        
    </xsl:template>
    
    <!-- Text based processing -->
    
    <xsl:template match="text()" mode="typesetting">
        <xsl:choose>
            <xsl:when test="count($_patterns/pattern) > 0">
                <xsl:call-template name="search-and-replace">
                    <xsl:with-param name="_content" select="."/>
                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[1]/search/text()"/>
                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[1]/replace/text()"/>
                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[1]/@ancestor"/>
                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[1]/@xml:lang"/>
                    <xsl:with-param name="_counter" select="1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>           
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Other functions -->
    
    <xsl:template name="language_attribute">
        <xsl:attribute name="xml:lang">
            <xsl:choose>
                <xsl:when test="ancestor-or-self::*[@xml:lang][1]/@xml:lang">
                    <xsl:value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>                                
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$_defaultLanguage"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="search-and-replace">
        <xsl:param name="_content"/>
        <xsl:param name="_searchpattern"/>
        <xsl:param name="_replacepattern"/>
        <xsl:param name="_pattern_ancestor"/>
        <xsl:param name="_pattern_language"/>
        <xsl:param name="_counter"/>
        
        <!-- Replace-Befehl -->
        
        <xsl:choose>
            <!-- Fall 1: Weder @ancestor, noch @xml:lang angegeben, d. h. Regel gilt für alles -->
            <xsl:when test="$_pattern_ancestor='' and $_pattern_language=''">
                
                <!-- Search and replace -->
                
                
                <!-- Rekursiver Aufruf -->
                
                <xsl:choose>
                    
                    <!-- Exit rule -->
                    
                    <xsl:when test="$_counter = count($_patterns/pattern)">
                        <xsl:value-of select="$_content"/>
                    </xsl:when>
                    
                    <!-- Process rule -->
                    
                    <xsl:otherwise>
                        <xsl:call-template name="search-and-replace">
                            <xsl:with-param name="_content" select="$_content"/>
                            <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                            <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                            <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                            <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                            <xsl:with-param name="_counter" select="$_counter+1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                    
                </xsl:choose>
                
            </xsl:when>
            <!-- Fall 2: @ancestor ist vorhanden, aber @xml:lang ist leer -->
            <xsl:when test="$_pattern_ancestor != '' and $_pattern_language = ''">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*/name() = $_pattern_ancestor">
                        
                        <xsl:variable name="_content">
                            <xsl:value-of select="replace($_content, $_searchpattern, $_replacepattern)"/>
                        </xsl:variable>
                        
                        <!-- Rekursiver Aufruf -->
                        
                        <xsl:choose>
                            <!-- Exit rule -->
                            <xsl:when test="$_counter = count($_patterns/pattern)">
                                <xsl:value-of select="$_content"/>
                            </xsl:when>
                            <!-- Process rule -->
                            <xsl:otherwise>
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="_content" select="$_content"/>
                                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                                    <xsl:with-param name="_counter" select="$_counter+1"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="_content" select="$_content"/>
                        
                        <!-- Rekursiver Aufruf -->
                        
                        <xsl:choose>
                            <!-- Exit rule -->
                            <xsl:when test="$_counter = count($_patterns/pattern)">
                                <xsl:value-of select="$_content"/>
                            </xsl:when>
                            <!-- Process rule -->
                            <xsl:otherwise>
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="_content" select="$_content"/>
                                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                                    <xsl:with-param name="_counter" select="$_counter+1"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Fall 3: Kein @ancestor, aber @xml:lang gegeben -->
            <xsl:when test="$_pattern_ancestor = '' and $_pattern_language != ''">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*[@xml:lang][1]/@xml:lang = $_pattern_language">
                        <xsl:variable name="_content">
                            <xsl:value-of select="replace($_content, $_searchpattern, $_replacepattern)"/>
                        </xsl:variable>
                        
                        <!-- Rekursiver Aufruf -->
                        
                        <xsl:choose>
                            <!-- Exit rule -->
                            <xsl:when test="$_counter = count($_patterns/pattern)">
                                <xsl:value-of select="$_content"/>
                            </xsl:when>
                            <!-- Process rule -->
                            <xsl:otherwise>
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="_content" select="$_content"/>
                                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                                    <xsl:with-param name="_counter" select="$_counter+1"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="_content" select="$_content"/>
                        
                        <!-- Rekursiver Aufruf -->
                        
                        <xsl:choose>
                            <!-- Exit rule -->
                            <xsl:when test="$_counter = count($_patterns/pattern)">
                                <xsl:value-of select="$_content"/>
                            </xsl:when>
                            <!-- Process rule -->
                            <xsl:otherwise>
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="_content" select="$_content"/>
                                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                                    <xsl:with-param name="_counter" select="$_counter+1"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Fall 4: Sowohl @ancestor als auch @xml:lang sind gegeben -->
            <xsl:when test="$_pattern_ancestor != '' and $_pattern_language != ''">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*/name() = $_pattern_ancestor and ancestor-or-self::*[@xml:lang][1]/@xml:lang = $_pattern_language">
                        <xsl:variable name="_content">
                            <xsl:value-of select="replace($_content, $_searchpattern, $_replacepattern)"/>
                        </xsl:variable>
                        
                        <!-- Rekursiver Aufruf -->
                        
                        <xsl:choose>
                            <!-- Exit rule -->
                            <xsl:when test="$_counter = count($_patterns/pattern)">
                                <xsl:value-of select="$_content"/>
                            </xsl:when>
                            <!-- Process rule -->
                            <xsl:otherwise>
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="_content" select="$_content"/>
                                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                                    <xsl:with-param name="_counter" select="$_counter+1"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="_content" select="$_content"/>
                        
                        <!-- Rekursiver Aufruf -->
                        
                        <xsl:choose>
                            <!-- Exit rule -->
                            <xsl:when test="$_counter = count($_patterns/pattern)">
                                <xsl:value-of select="$_content"/>
                            </xsl:when>
                            <!-- Process rule -->
                            <xsl:otherwise>
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="_content" select="$_content"/>
                                    <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                                    <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                                    <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                                    <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                                    <xsl:with-param name="_counter" select="$_counter+1"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="_content" select="$_content"/>
                
                <!-- Rekursiver Aufruf -->
                
                <xsl:choose>
                    <!-- Exit rule -->
                    <xsl:when test="$_counter = count($_patterns/pattern)">
                        <xsl:value-of select="$_content"/>
                    </xsl:when>
                    <!-- Process rule -->
                    <xsl:otherwise>
                        <xsl:call-template name="search-and-replace">
                            <xsl:with-param name="_content" select="$_content"/>
                            <xsl:with-param name="_searchpattern" select="$_patterns/pattern[$_counter+1]/search/text()"/>
                            <xsl:with-param name="_replacepattern" select="$_patterns/pattern[$_counter+1]/replace/text()"/>
                            <xsl:with-param name="_pattern_ancestor" select="$_patterns/pattern[$_counter+1]/@ancestor"/>
                            <xsl:with-param name="_pattern_language" select="$_patterns/pattern[$_counter+1]/@xml:lang"/>
                            <xsl:with-param name="_counter" select="$_counter+1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="contributor_names">
        <xsl:param name="_contrib-type"/>
        <xsl:param name="_xpath-expression"/>
        <xsl:for-each select="($_xpath-expression)/contrib[@contrib-type=$_contrib-type]">
            <xsl:if test="position()>1">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="name/given-names"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="name/surname"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Table of Contents -->
    
    <xsl:template name="table-of-contents">
        
        <fo:page-sequence master-reference="complex_page_sequence" force-page-count="even">
            
            <!-- Page number format -->
            <xsl:attribute name="format">
                <xsl:choose>
                    <xsl:when test="/book/@book-type='monograph'">
                        <xsl:value-of select="$_front-matterMonographPagination"/>
                    </xsl:when>
                    <xsl:when test="/book/@book-type='proceedings'">
                        <xsl:value-of select="$_front-matterProceedingsPagination"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>i</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <!-- Multivolume output -->
            <xsl:if test="$formatter='ah'">
                <xsl:attribute name="axf:output-volume-break">true</xsl:attribute>
            </xsl:if>

            <!-- Footnote separator line -->
            <xsl:call-template name="footnote_separator_line"/>
            
            <!-- Static content -->
            <xsl:call-template name="static_content"/>
            
            <!-- Text flow -->
            <fo:flow flow-name="xsl-region-body">
                
                <fo:marker marker-class-name="chapter-title">
                    <xsl:choose>
                        <xsl:when test="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]">
                            <xsl:value-of select="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Table of Contents</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:marker>
                
                <fo:marker marker-class-name="heading-1">
                    <xsl:choose>
                        <xsl:when test="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]">
                            <xsl:value-of select="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Table of Contents</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:marker>
                
                <fo:marker marker-class-name="authors">
                    <xsl:choose>
                        <xsl:when test="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]">
                            <xsl:value-of select="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Table of Contents</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
               </fo:marker> 
                      
                <xsl:element name="fo:block-container" use-attribute-sets="chapter_title_margins">
                    <xsl:element name="fo:block" use-attribute-sets="chapter_heading">
                        <!-- ID -->
                        <xsl:attribute name="id">ToC</xsl:attribute>
                        
                        <!-- Heading -->
                        <xsl:choose>
                            <xsl:when test="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]">
                                <xsl:value-of select="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Table of Contents</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            
                <!-- ToC block -->
                
                <xsl:element name="fo:list-block">
                
                    <!-- Front matter -->
                    <xsl:apply-templates select="/book/front-matter" mode="ToC"/>
                
                    <!-- Text -->
                    <xsl:apply-templates select="/book/book-body" mode="ToC"/>
                
                    <!-- Back matter -->
                    <xsl:apply-templates select="/book/book-back" mode="ToC"/>
                
                </xsl:element>
                
            </fo:flow>
            
        </fo:page-sequence>
        
    </xsl:template>

    <xsl:template match="book-app | book-app-group | book-part | dedication | foreword | front-matter-part | preface" mode="ToC">

        <xsl:choose>
            <xsl:when test="book-part-meta/title-group">
                
                <xsl:element name="fo:list-item">
                    <xsl:choose>
                        <!-- Insert Spaces before and after parts -->
                        <xsl:when test="self::book-part and @book-part-type='part'">
                            <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                            <xsl:attribute name="space-after" select="$_regularLineHeight"/>
                        </xsl:when>
                        <!-- Insert a space after the front matter -->
                        <xsl:when test="parent::book-body and not(preceding-sibling::*) and parent::book-body[preceding-sibling::front-matter]">
                            <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                        </xsl:when>
                        <!-- Insert a space after the text body -->
                        <xsl:when test="parent::book-back and not(preceding-sibling::*) and (parent::book-back[preceding-sibling::front-matter] or parent::book-back[preceding-sibling::book-body])">
                            <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:element name="fo:list-item-label">
                            <!--<xsl:attribute name="end-indent">label-end()</xsl:attribute>-->
                        <xsl:choose>
                            <xsl:when test="book-part-meta/title-group/label and not(contains(book-part-meta/title-group/label,' '))">
                                <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                <xsl:element name="fo:block">
                                    <xsl:value-of select="book-part-meta/title-group/label"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:block/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    
                    <xsl:element name="fo:list-item-body">
                            <!-- <xsl:attribute name="start-indent">body-start()</xsl:attribute> -->
                            <xsl:if test="book-part-meta/title-group/label and not(contains(book-part-meta/title-group/label,' '))">
                                <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                            </xsl:if>
                        
                            <fo:block>
                                <xsl:attribute name="text-align">left</xsl:attribute>
                                <xsl:attribute name="text-align-last">justify</xsl:attribute>
                                <xsl:attribute name="end-indent">1.5cm</xsl:attribute>
                                <xsl:attribute name="last-line-end-indent">-1.5cm</xsl:attribute>
                                
                                <xsl:if test="book-part-meta/title-group/label and contains(book-part-meta/title-group/label,' ')">
                                    <xsl:value-of select="book-part-meta/title-group/label"/>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                
                                <!-- Title -->
                                <xsl:if test="book-part-meta/title-group/title">
                                    <xsl:value-of select="book-part-meta/title-group/title"/>
                                    <xsl:if test="book-part-meta/title-group/subtitle">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:if>
                                
                                <!-- Sub title -->
                                <xsl:if test="book-part-meta/title-group/subtitle">
                                    <xsl:value-of select="book-part-meta/title-group/subtitle"/>
                                </xsl:if>
                                
                                <!-- Leader -->
                                <xsl:call-template name="toc_leader"/>
                                
                                <!-- Page number -->
                                <xsl:call-template name="toc_page_number"/>
                            
                                <!-- Check for relevant subsequent parts -->
                                <xsl:if test="child::front-matter
                                   or child::body
                                   or child::back
                                   or child::sec[child::label or child::title or child::subtitle]
                                   or child::book-app
                                   or child::named-book-part-body[child::sec[child::label or child::title or child::subtitle] or child::def-list[child::label or child::title]]">
                                     
                                   <xsl:element name="fo:list-block">
                                       <xsl:apply-templates mode="#current"/>
                                   </xsl:element>
                                </xsl:if>
                            </fo:block>
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:otherwise>
                <!-- Check for relevant subsequent parts -->
                <xsl:if test="child::front-matter
                    or child::body
                    or child::back
                    or child::sec[child::label or child::title or child::subtitle]
                    or child::book-app
                    or child::named-book-part-body[child::sec[child::label or child::title or child::subtitle] or child::def-list[child::label or child::title]]">
                    
                    <xsl:element name="fo:list-block">
                        <xsl:apply-templates mode="#current"/>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <xsl:template match="ack | app | app-group | bio | def-list | fn-group | glossary | index-title-group | notes | ref-list | sec | toc-title-group" mode="ToC">

        <xsl:if test="(self::fn-group and not($_footnote_handling='footnotes')) or (not(self::fn-group) and (label or title or subtitle))">

          <xsl:element name="fo:list-item">
              <xsl:choose>
                  <!-- Insert Spaces before and after parts -->
                  <xsl:when test="self::book-part and @book-part-type='part'">
                      <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                      <xsl:attribute name="space-after" select="$_regularLineHeight"/>
                  </xsl:when>
                  <xsl:when test="parent::book-body and not(preceding-sibling::*) and parent::book-body[preceding-sibling::front-matter]">
                      <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                  </xsl:when>
                  <!-- Insert a space after the text body -->
                  <xsl:when test="parent::book-back and not(preceding-sibling::*) and (parent::book-back[preceding-sibling::front-matter] or parent::book-back[preceding-sibling::book-body])">
                      <xsl:attribute name="space-before" select="$_regularLineHeight"/>
                  </xsl:when>
              </xsl:choose>
              
              <xsl:element name="fo:list-item-label">
                  <!-- <xsl:attribute name="end-indent">label-end()</xsl:attribute> -->
                 <xsl:choose>   
                      <xsl:when test="label and not(contains(label,' '))">
                          <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                          <xsl:element name="fo:block">
                            <xsl:value-of select="label"/>
                          </xsl:element>
                      </xsl:when>
                    <xsl:otherwise>
                        <fo:block/>
                    </xsl:otherwise>
                 </xsl:choose>
              </xsl:element>
              
              <xsl:element name="fo:list-item-body">
                  <!-- <xsl:attribute name="start-indent">body-start()</xsl:attribute> -->
                  <xsl:if test="label and not(contains(label,' '))">
                      <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                  </xsl:if>
                  <xsl:element name="fo:block">
                      <xsl:attribute name="text-align">left</xsl:attribute>
                      <xsl:attribute name="text-align-last">justify</xsl:attribute>
                      <xsl:attribute name="end-indent">1.5cm</xsl:attribute>
                      <xsl:attribute name="last-line-end-indent">-1.5cm</xsl:attribute>

                      <xsl:if test="label and contains(label,' ')">
                          <xsl:apply-templates select="label" mode="#current"/>
                          <xsl:text> </xsl:text>
                      </xsl:if>
                      
                      <!-- Title -->
                      <xsl:if test="title">
                          <xsl:value-of select="title"/>
                          <xsl:if test="subtitle">
                              <xsl:text>. </xsl:text>
                          </xsl:if>
                      </xsl:if>
                      
                      <!-- Sub title -->
                      <xsl:if test="subtitle">
                          <xsl:value-of select="subtitle"/>
                      </xsl:if>
                      
                      <!-- Leader -->
                      <xsl:call-template name="toc_leader"/>
                      
                      <!-- Page number -->
                      <xsl:call-template name="toc_page_number"/>
                  </xsl:element>
                  
                  <!-- Check for relevant subsequent parts -->
                  <xsl:if test="child::notes[child::label or child::title or child::subtitle]
                      or child::ref-list[child::label or child::title or child::subtitle]
                      or child::sec[child::label or child::title or child::subtitle]
                      or child::def-list[child::label or child::title]
                      or child::glossary[child::label or child::title or child::subtitle]">
                      
                      <xsl:element name="fo:list-block">
                          <xsl:apply-templates mode="#current"/>
                      </xsl:element>
                  </xsl:if>
                  
              </xsl:element>
              
          </xsl:element>
            
        </xsl:if>

    </xsl:template>

    <xsl:template name="toc_leader">
        <xsl:text>&#160;</xsl:text>
        <fo:leader leader-pattern="dots"/>
        <xsl:text>&#160;</xsl:text>
    </xsl:template>

    <xsl:template name="toc_page_number">
        <xsl:element name="fo:page-number-citation">
            <xsl:attribute name="ref-id">
                 <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text()" mode="ToC"/>
    
    <xsl:template match="*" mode="ToC">
        <xsl:apply-templates mode="#current"/>        
    </xsl:template>
    
    <!-- PDF Bookmarks -->
    
    <xsl:template name="pdf_bookmarks">
        <xsl:if test="$medium='interactive' and $_pdf_bookmarks='yes'">

            <fo:bookmark-tree>
            
                <!-- Front cover and front cover verso page -->
                
                    <!-- [...] -->
                
                <!-- Front matter -->
            
                    <!-- Prelims -->
                    <xsl:element name="fo:bookmark">
                        <xsl:attribute name="internal-destination">prelims</xsl:attribute>
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="$_localization/localization-group[@name='preliminaries']/localization-item[@xml:lang=$_bookLanguage]">
                                    <xsl:value-of select="$_localization/localization-group[@name='preliminaries']/localization-item[@xml:lang=$_bookLanguage]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Preliminaries</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:bookmark-title>
                    </xsl:element>
                    
                    <!-- Auto generated divisions:
                            - Outline / Inhaltsübersicht
                            - Table of Contents
                            - List of Figures
                            - List of Tables -->
    
                    <!-- Front matter divisions -->
                
                    <!-- Dedication and Epigraph before the ToC -->
                    <xsl:apply-templates select="/book/front-matter/dedication | /book/front-matter/front-matter-part[@book-part-type='epigraph']" mode="pdf-bookmarks"/>

                    <!-- Table of Contents -->
                    <xsl:element name="fo:bookmark">
                        <xsl:attribute name="internal-destination">ToC</xsl:attribute>
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]">
                                    <xsl:value-of select="$_localization/localization-group[@name='table-of-contents']/localization-item[@xml:lang=$_bookLanguage]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Dedication</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:bookmark-title>
                    </xsl:element>

                    <!-- All other front matter parts -->
                    <xsl:apply-templates select="/book/front-matter/node() except /book/front-matter/dedication except /book/front-matter/front-matter-part[@book-part-type='epigraph']" mode="pdf-bookmarks"/>

                    <!-- Text -->

                    <xsl:apply-templates select="/book/book-body/node()" mode="pdf-bookmarks"/>
                
                    <!-- Back matter -->

                    <xsl:apply-templates select="/book/book-back/node()" mode="pdf-bookmarks"/>
                                
                   <!-- Back cover verso page and back cover -->
            
            </fo:bookmark-tree>
            
        </xsl:if>
    </xsl:template>

    <xsl:template match="book-app | book-app-group | book-part | dedication | foreword | front-matter-part | preface" mode="pdf-bookmarks">
        <xsl:element name="fo:bookmark">
            <xsl:attribute name="internal-destination">
                <xsl:value-of select="ancestor-or-self::*[@id][1]/@id"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="book-part-meta/title-group">
                    <xsl:apply-templates select="book-part-meta/title-group" mode="pdf-bookmarks_subgroup"/>                    
                </xsl:when>
                <xsl:when test="self::dedication">
                    <fo:bookmark-title>
                        <xsl:choose>
                            <xsl:when test="$_localization/localization-group[@name='dedication']/localization-item[@xml:lang=$_bookLanguage]">
                                <xsl:value-of select="$_localization/localization-group[@name='dedication']/localization-item[@xml:lang=$_bookLanguage]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Dedication</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:bookmark-title>
                </xsl:when>
                <xsl:when test="self::front-matter-part[@book-part-type='epigraph']">
                    <fo:bookmark-title>
                        <xsl:choose>
                            <xsl:when test="$_localization/localization-group[@name='epigraph']/localization-item[@xml:lang=$_bookLanguage]">
                                <xsl:value-of select="$_localization/localization-group[@name='epigraph']/localization-item[@xml:lang=$_bookLanguage]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Epigraph</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:bookmark-title>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="ack | app | app-group | bio | def-list | fn-group | glossary | index-title-group | notes | ref-list | sec | toc-title-group" mode="pdf-bookmarks">
        <xsl:choose>
            <xsl:when test="label or title or subtitle">
                <xsl:if test="(self::fn-group and $_footnote_handling='book-back-matter') or not(self::fn-group)">
                    <xsl:element name="fo:bookmark">
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="ancestor-or-self::*[@id][1]/@id"/>
                        </xsl:attribute>
                        <xsl:call-template name="pdf-bookmark-title"/>
                        <xsl:apply-templates mode="#current"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="#current"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="title-group" mode="pdf-bookmarks_subgroup">
        <xsl:call-template name="pdf-bookmark-title"/>
    </xsl:template>

    <xsl:template name="pdf-bookmark-title">
        <xsl:if test="label or title or subtitle">
            <fo:bookmark-title>
                <xsl:if test="label">
                    <xsl:value-of select="label"/>
                </xsl:if>
                <xsl:if test="title">
                    <xsl:if test="label">
                        <xsl:text>&#160;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="title"/>
                    <xsl:if test="subtitle">
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="subtitle">
                    <xsl:value-of select="subtitle"/>
                </xsl:if>
            </fo:bookmark-title>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="pdf-bookmarks">
        <xsl:apply-templates mode="#current"/>        
    </xsl:template>

    <xsl:template match="text()" mode="pdf-bookmarks"/>
    
</xsl:stylesheet>