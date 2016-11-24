<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs" version="2.0">

<!-- **********************************************************
     * HeiUP PDF Formatter for XSL FO 1.1                     *
     *                                  Not for production!   *
     * Contact:      Frank Krabbes                            *
     *               krabbes@ub.uni-heidelberg.de             *
     +               Copyright 2016 CC-BY-NC-ND               *
     **********************************************************

     **********************************************************
     * Variable definitions and include files                 *
     ********************************************************** -->

    <!-- Definition of the output medium: Defines if PDF files optimized for print or electronic publishing are generated.
        Values: electronic, print)
        Should be be implemented as parameter later.
        This parameter triggers the PDF version (PDF/A; PDF/X) for the Antenna House Formatter. -->
    <xsl:variable name="medium">electronic</xsl:variable>

    <!-- PDF bookmarks: Defines if PDF bookmarks will be generated.
            Values: yes, no
        Recommendation: should be 'no' for print, 'yes' for electronic publishing-->
    <xsl:variable name="generate_pdf_bookmarks">yes</xsl:variable> <!-- not implemented yet -->

    <!-- Defines the renderer used: Defines if proprietary code will be generated.
        Values: FOP, XEP, AntennaHouse -->
    <xsl:variable name="formatter">AntennaHouse</xsl:variable>

    <!-- Include template containing paragraph and characzer styles etc. -->
    <xsl:include href="heiup_template_generic_m.xsl"/>   
   
<!-- **********************************************************
     * Page formatting                                        *
     ********************************************************** -->
    
    <xsl:template match="/article">
        
        <fo:root> 
        
            <!-- **********************************************************
                 * Page templates and page sequences                      *
                 ********************************************************** -->
            
            <fo:layout-master-set>
                
                <!-- **********************************************************
                     * Page templates                                         *
                     ********************************************************** -->
                
                <!-- Chapter title pages -->
                <fo:simple-page-master master-name="Chapter_First_Recto">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <!-- no running titles on first page of a chapter -->
                    <fo:region-after extent="10mm" display-align="after"/>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master master-name="Chapter_First_Verso">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select=" $MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <!-- no running titles on first page of a chapter -->
                    <fo:region-after extent="10mm" display-align="after"/>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>
                
                <!-- Regular chapter pages -->
                <fo:simple-page-master master-name="Chapter_Recto">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-before region-name="column_title_recto" extent="10mm" display-align="before"/>
                    <fo:region-after extent="10mm" display-align="after"/>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="Chapter_Verso">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select=" $MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-before region-name="column_title_verso" extent="10mm" display-align="before"/>
                    <fo:region-after extent="10mm" display-align="after"/>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>
                
                <!-- Chapter last pages -->
                <fo:simple-page-master master-name="Chapter_Last_Recto">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <!-- no page number on foot on last page -->
                    <fo:region-before region-name="column_title_recto" extent="10mm" display-align="before"/>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master master-name="Chapter_Last_Verso">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select=" $MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <!-- no page number on foot on last page -->
                    <fo:region-before region-name="column_title_verso" extent="10mm" display-align="before"/>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>
                
                <!-- Empty page -->
                <fo:simple-page-master master-name="Empty_Page">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>

                <!-- **********************************************************
                     * Page sequences                                         *
                     ********************************************************** -->
                
                <fo:page-sequence-master master-name="Chapter_Sequence">
                    <fo:repeatable-page-master-alternatives>
                        <!-- Firsts -->
                        <fo:conditional-page-master-reference page-position="first" odd-or-even="odd"
                            master-reference="Chapter_First_Recto"/>
                        <fo:conditional-page-master-reference page-position="first" odd-or-even="even"
                            master-reference="Chapter_First_Verso"/>
                        <!-- Rest of pages -->
                        <fo:conditional-page-master-reference page-position="rest" odd-or-even="odd"
                            master-reference="Chapter_Recto"/>
                        <fo:conditional-page-master-reference page-position="rest" odd-or-even="even"
                            master-reference="Chapter_Verso"/>
                        <!-- Last pages -->
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="even"
                            blank-or-not-blank="blank" master-reference="Empty_Page"/>
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="odd"
                            blank-or-not-blank="not-blank" master-reference="Chapter_Last_Recto"/>
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="even"
                            blank-or-not-blank="not-blank" master-reference="Chapter_Last_Verso"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
                
            </fo:layout-master-set>
            
            <!-- **********************************************************
                 * FO Declarations                                        *
                 ********************************************************** -->
            <fo:declarations>
                
                <!-- Embed color profiles -->
                <fo:color-profile>
                    <xsl:attribute name="src">
                        <xsl:value-of select="$ColorProfile_CMYK"/>
                    </xsl:attribute>
                    <xsl:attribute name="color-profile-name">#CMYK</xsl:attribute>
                </fo:color-profile>
                <fo:color-profile>
                    <xsl:attribute name="src">
                        <xsl:value-of select="$ColorProfile_RGB"/>
                    </xsl:attribute>
                    <xsl:attribute name="color-profile-name">#RGB</xsl:attribute>
                </fo:color-profile>

                <!-- Formatter specific PDF configuration -->
                <xsl:if test="$formatter='AntennaHouse'">
                    <axf:formatter-config xmlns:axs="http://www.antennahouse.com/names/XSL/Settings">
                          <xsl:choose>
                              <xsl:when test="$medium='electronic'">
                                   <axs:pdf-settings tagged-pdf="true">
                                        <xsl:attribute name="tagged-pdf">true</xsl:attribute>
                                        <xsl:attribute name="pdf-version">
                                             <xsl:value-of select="$Electronic_PDF_Standard"/>
                                        </xsl:attribute>
                                   </axs:pdf-settings>
                              </xsl:when>
                              <xsl:when test="$medium='print'">
                                   <axs:pdf-settings tagged-pdf="true">
                                        <xsl:attribute name="tagged-pdf">true</xsl:attribute>
                                        <xsl:attribute name="pdf-version">
                                             <xsl:value-of select="$Print_PDF_Standard"/>
                                        </xsl:attribute>
                                   </axs:pdf-settings>
                              </xsl:when>
                         </xsl:choose>
                    </axf:formatter-config>
                </xsl:if>
                
            </fo:declarations>
            
            <!-- **********************************************************
                 * PDF bookmark tree                                      *
                 ********************************************************** -->
            <xsl:if test="$generate_pdf_bookmarks='yes'">
                <!-- Not implemented yet -->
            </xsl:if>
            
            <!-- **********************************************************
                 * Chapter typesetting                                    *
                 ********************************************************** -->
            <fo:page-sequence master-reference="Chapter_Sequence">
                <!-- defines if chapters have an even page count or not --> 
                <xsl:attribute name="force-page-count">
                    <xsl:value-of select="$ChapterPageHandling"/>
                </xsl:attribute>
                
                <!-- Footnote separator -->
                <xsl:if test="$footnote-separator='yes'">
                    <fo:static-content flow-name="xsl-footnote-separator">
                        <fo:block text-align-last="justify">                         
                            <xsl:element name="fo:leader" use-attribute-sets="footnote_sep"/>
                        </fo:block>
                    </fo:static-content>
                </xsl:if>
                
                <!-- Page number at bottom of the page, for BookType='simple' only -->
                <xsl:if test="$BookType='simple'">
                  <fo:static-content flow-name="xsl-region-after">
                      <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph page_number_page_bottom">
                         <fo:page-number/>
                      </xsl:element>
                   </fo:static-content>
                </xsl:if>

                <!-- Running headers -->
                <xsl:if test="not($BookType='simple')">
                    <fo:static-content flow-name="column_title_verso">
                        <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_verso">
                            <fo:page-number/>
                            <xsl:text> – </xsl:text>
                            <fo:retrieve-marker retrieve-boundary="document" retrieve-class-name="running_head_left"/>
                        </xsl:element>
                    </fo:static-content>
                    <fo:static-content flow-name="column_title_recto">
                        <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_recto">
                            <fo:retrieve-marker retrieve-boundary="document" retrieve-class-name="running_head_right"/>
                            <xsl:text> – </xsl:text>
                            <fo:page-number/>
                        </xsl:element>
                    </fo:static-content>
                </xsl:if>
                
                <!-- Text flow -->
                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <xsl:apply-templates mode="typesetting"/>
                    </fo:block>
                </fo:flow>
 
            </fo:page-sequence>
            
        </fo:root>

    </xsl:template>

    <!-- Ignore the article frontmatter -->
    <xsl:template match="front" mode="typesetting"/>
        
    <xsl:template match="body" mode="typesetting">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <!-- **********************************************************
         * Headings                                               *
         ********************************************************** -->
    <xsl:template match="title" mode="typesetting">
        <!-- Parent elements: app, boxed-text, sec -->
        <!-- Retrieve the hierarchy level of the heading -->
        <xsl:variable name="hierarchy_level">
            <xsl:value-of select="count(ancestor::sec)"/>
        </xsl:variable>
        <fo:block>
            <xsl:choose>
                <xsl:when test="$BookType='monograph'">
                    <xsl:if test="$hierarchy_level='1'">
                        <fo:marker marker-class-name="running_head_left">
                            <xsl:apply-templates mode="typesetting"/>
                        </fo:marker>
                    </xsl:if>
                    <xsl:if test="$hierarchy_level='2'">
                        <fo:marker marker-class-name="running_head_right">
                            <xsl:apply-templates mode="typesetting"/>
                        </fo:marker>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates mode="typesetting"/>
        </fo:block>
    </xsl:template>
    
    <!-- **********************************************************
         * Paragraphs                                             *
         ********************************************************** -->
    <xsl:template match="p" mode="typesetting">
        <xsl:choose>
            <xsl:when test="parent::fn">
                <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text paragraph_formats hyphenate keeps-paragraph">
                    <!-- Insert Footnote label into the first paragraph -->
                    <xsl:if test="not(./preceding-sibling::p)">
                        <xsl:variable name="footnote_id" select="ancestor::fn/@id"/>
                        <xsl:choose>
                            <!-- Hyperlink for electronic PDF -->
                            <xsl:when test="$medium='electronic'">
                                <xsl:element name="fo:inline" use-attribute-sets="hyperlink">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="ancestor::fn/@id"/>
                                    </xsl:attribute>
                                    <xsl:variable name="backlink">
                                        <xsl:value-of select="$footnote_id"/><xsl:text>_backlink</xsl:text>
                                    </xsl:variable>
                                    <fo:basic-link internal-destination="{$backlink}">
                                        <xsl:value-of select="/descendant::xref[@rid=$footnote_id]"/>
                                    </fo:basic-link>
                                </xsl:element>
                            </xsl:when>
                            <!-- Text only in the non electronic PDF -->
                            <xsl:otherwise>
                                <fo:inline>
                                    <xsl:value-of select="/descendant::xref[@rid=$footnote_id]"/>
                                </fo:inline>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>                
            </xsl:when>
            <xsl:when test="parent::disp-quote">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][self::p]">
                        <xsl:element name="fo:block" use-attribute-sets="indents-disp-quote_first_line">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::table-wrap">
                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::*[1][self::p])">
                        <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text paragraph_formats hyphenate keeps-paragraph">
                            <xsl:element name="fo:inline" use-attribute-sets="caption_labels">
                                <xsl:apply-templates select="../../label"/><xsl:text>. </xsl:text>
                            </xsl:element>
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text paragraph_formats hyphenate keeps-paragraph">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][self::p]">
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph indents-paragraph_first_line">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- **********************************************************
         * Cross references to footnotes, figures, tables etc.    *
         ********************************************************** -->
    <xsl:template match="xref" mode="typesetting">
        <xsl:choose>
            <!-- Footnotes -->
            <xsl:when test="(@ref-type='fn')">
                <!-- Check if footnotes should be treated as foot- or endnotes -->
                <xsl:choose>
                    <!-- Endnote formatting -->
                    <xsl:when test="$FootnoteHandling='endnote'">
                        <!-- to be implemented -->
                    </xsl:when>
                    <!-- Footnote formatting -->
                    <xsl:otherwise>
                        <xsl:variable name="fn_id" select="@rid"/>
                        <fo:footnote>
                            <xsl:choose>
                                <xsl:when test="$medium='electronic'">
                                    <xsl:element name="fo:inline" use-attribute-sets="footnote_reference_number hyperlink">
                                        <xsl:attribute name="id">
                                            <xsl:variable name="backlink">
                                                <xsl:value-of select="@rid"/><xsl:text>_backlink</xsl:text>
                                            </xsl:variable>
                                            <xsl:value-of select="$backlink"/>
                                        </xsl:attribute>
                                        <fo:basic-link internal-destination="{@rid}">
                                            <xsl:apply-templates mode="typesetting"/> 
                                        </fo:basic-link>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="fo:inline" use-attribute-sets="footnote_reference_number">
                                        <xsl:apply-templates mode="typesetting"/> 
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                             <fo:footnote-body>
                                <xsl:apply-templates select="/article/back/fn-group/fn[@id=$fn_id]" mode="typesetting"/>
                            </fo:footnote-body>
                        </fo:footnote>
                    </xsl:otherwise>                    
                </xsl:choose>
            </xsl:when>
            <xsl:when test="(@ref-type='table')">
                <xsl:choose>
                    <xsl:when test="$medium='electronic'">
                        <xsl:element name="fo:inline" use-attribute-sets="hyperlink">
                            <fo:basic-link internal-destination="{@rid}">
                                <xsl:apply-templates mode="typesetting"/>
                            </fo:basic-link>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:inline">
                            <xsl:apply-templates mode="typesetting"/> 
                        </xsl:element>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- All other xref types -->
            <xsl:otherwise>
                <xsl:apply-templates mode="typesetting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ********************************************************** -->
    <!-- * Endnotes                                               * -->
    <!-- ********************************************************** -->
    <xsl:template match="fn-group" mode="typesetting">
        <xsl:if test="$FootnoteHandling='endnote'">
            <!-- to define -->
        </xsl:if> 
    </xsl:template>
    
    <!-- ********************************************************** -->
    <!-- * Block quotes                                           * -->
    <!-- ********************************************************** -->
    <xsl:template match="disp-quote" mode="typesetting">
        <xsl:element name="fo:block-container" use-attribute-sets="fonts_petit_text hyphenate keeps-paragraph paragraph_formats indents-disp-quote">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * External hyperlinks                                    * -->
    <!-- ********************************************************** -->
    <xsl:template match="ext-link" mode="typesetting">
        <xsl:choose>
            <xsl:when test="$medium='electronic'">
                <xsl:element name="fo:basic-link" use-attribute-sets="hyperlink">
                    <xsl:attribute name="external-destination">
                        <xsl:value-of select="node()"/>
                    </xsl:attribute>
                    <xsl:attribute name="show-destination">new</xsl:attribute>
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="typesetting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    <!-- ********************************************************** -->
    <!-- * Basic Math                                             * -->
    <!-- ********************************************************** -->
    <xsl:template match="disp-formula" mode="typesetting">
        <xsl:apply-templates mode="typesetting"/>      
    </xsl:template>
    
    <xsl:template match="mml:math" mode="typesetting">
        <!-- Inline formulae -->
        <xsl:choose>
            <xsl:when test="(ancestor::table-wrap) | (ancestor::p)">
                <xsl:element name="fo:inline">
                    <fo:instream-foreign-object>
                        <mml:math display="inline" xmlns:mml="http://www.w3.org/1998/Math/MathML">
                            <xsl:copy-of select="node()"/>
                        </mml:math>
                    </fo:instream-foreign-object>
                </xsl:element>
            </xsl:when>
            <!-- Block level formulae -->
            <xsl:otherwise>
                <xsl:element name="fo:block" use-attribute-sets="table_margins">
                    <fo:instream-foreign-object>
                        <mml:math display="block" xmlns:mml="http://www.w3.org/1998/Math/MathML">
                            <xsl:copy-of select="node()"/>
                        </mml:math>
                    </fo:instream-foreign-object>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Tables                                                 * -->
    <!-- ********************************************************** -->
    <xsl:template match="table-wrap" mode="typesetting">
        <xsl:element name="fo:table-and-caption" use-attribute-sets="table_margins">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
     </xsl:template>
    
    <xsl:template match="table" mode="typesetting">
        <xsl:element name="fo:table">
            <xsl:attribute name="border-style">solid</xsl:attribute>
            <xsl:attribute name="border-width">0.75pt</xsl:attribute>
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="thead" mode="typesetting">
        <xsl:element name="fo:table-header">
            <xsl:attribute name="border-style">solid</xsl:attribute>
            <xsl:attribute name="border-width">0.75pt</xsl:attribute>
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tbody" mode="typesetting">
        <xsl:element name="fo:table-body">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tfoot" mode="typesetting">
        <xsl:element name="fo:table-footer">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tr" mode="typesetting">
        <xsl:element name="fo:table-row">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="th | td" mode="typesetting">
        <xsl:element name="fo:table-cell">
            <xsl:attribute name="border-style">solid</xsl:attribute>
            <xsl:attribute name="border-width">0.5pt</xsl:attribute>
            <xsl:attribute name="number-columns-spanned">
                <xsl:value-of select="@colspan"/>
            </xsl:attribute>            
            <xsl:attribute name="number-rows-spanned">
                <xsl:value-of select="@rowspan"/>
            </xsl:attribute>
            <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text keeps-paragraph hyphenate">
                <xsl:apply-templates mode="typesetting"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Captions                                               * -->
    <!-- ********************************************************** -->
    <xsl:template match="caption" mode="typesetting">
        <xsl:choose>
            <xsl:when test="parent::table-wrap">
                <xsl:element name="fo:table-caption">
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="typesetting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="label" mode="typesetting">
        <xsl:if test="not(ancestor::table-wrap)">
            <xsl:apply-templates mode="typesetting"/>           
        </xsl:if>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Inline formats                                         * -->
    <!-- ********************************************************** -->
    
    <!-- Italics -->
    <xsl:template match="italic" mode="typesetting">
        <fo:inline font-style="italic">
            <xsl:apply-templates mode="typesetting"/>
        </fo:inline>
    </xsl:template>

    <!-- Bold -->
    <xsl:template match="bold" mode="typesetting">
        <fo:inline font-weight="bold">
            <xsl:apply-templates mode="typesetting"/>
        </fo:inline>
    </xsl:template>

    <!-- Small Caps -->
    <xsl:template match="sc" mode="typesetting">
        <fo:inline font-variant="small-caps">
            <xsl:apply-templates mode="typesetting"/>
        </fo:inline>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Break                                                  * -->
    <!-- ********************************************************** -->
    <xsl:template match="break" mode="typesetting">
        <fo:block/>
    </xsl:template>

</xsl:stylesheet>