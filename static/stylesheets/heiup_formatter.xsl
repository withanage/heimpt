<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs" version="2.0">

<!-- **********************************************************
     * HeiUP PDF Formatter for XSL FO 1.1                     *
     *                                  Not for production!   *
     * Contact:      Frank Krabbes                            *
     *               krabbes@ub.uni-heidelberg.de             *
     **********************************************************

     **********************************************************
     * Variable definitions and include files                 *
     ********************************************************** -->

    <!-- Definition of the output medium: Defines if PDF files optimized for print or electronic publishing are generated.
        Values: electronic, print)
        Should be be implemented as parameter later
        This parameter triggers the PDF version (PDF/A; PDF/X) for the Antenna House Formatter -->
    <xsl:variable name="medium">electronic</xsl:variable>

    <!-- PDF bookmarks: Defines if PDF bookmarks will be generated.
            Values: yes, no
        Recommendation: should be 'no' for print, 'yes' for electronic publishing-->
    <xsl:variable name="generate_pdf_bookmarks">yes</xsl:variable>

    <!-- Definition of the renderer: Defines if proprietary code will be generated.
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
                    <fo:region-body/>
                </fo:simple-page-master>
                
                <fo:simple-page-master master-name="Chapter_First_Verso">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select=" $MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>
                
                <!-- Regular chapter pages -->
                <fo:simple-page-master master-name="Chapter_Recto">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="Chapter_Verso">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select=" $MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>
                
                <!-- Chapter last pages -->
                <fo:simple-page-master master-name="Chapter_Last_Recto">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>
                
                <fo:simple-page-master master-name="Chapter_Last_Verso">
                    <xsl:attribute name="page-height"><xsl:value-of select="$PageHeight"/></xsl:attribute>
                    <xsl:attribute name="page-width"><xsl:value-of select="$PageWidth"/></xsl:attribute>
                    <xsl:attribute name="margin-left"><xsl:value-of select=" $MarginOuter"/></xsl:attribute>
                    <xsl:attribute name="margin-right"><xsl:value-of select="$MarginInner"/></xsl:attribute>
                    <xsl:attribute name="margin-top"><xsl:value-of select="$MarginTop"/></xsl:attribute>
                    <xsl:attribute name="margin-bottom"><xsl:value-of select="$MarginBottom"/></xsl:attribute>
                    <fo:region-body/>
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
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="odd"
                            master-reference="Chapter_Last_Recto"/>
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="even"
                            master-reference="Chapter_Last_Verso"/>
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="even"
                            blank-or-not-blank="blank" master-reference="Empty_Page"/>                        
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
                <!--
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
                -->
                
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
                        <fo:inline>
                            <xsl:value-of select="/descendant::xref[@rid=$footnote_id]"></xsl:value-of>
                        </fo:inline>
                    </xsl:if>
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph">
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>
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
                            <xsl:element name="fo:inline" use-attribute-sets="footnote_reference_number">
                                <xsl:apply-templates mode="typesetting"/> 
                            </xsl:element>
                            <fo:footnote-body>
                                <xsl:apply-templates select="/article/back/fn-group/fn[@id=$fn_id]" mode="typesetting"/>
                            </fo:footnote-body>
                        </fo:footnote>
                    </xsl:otherwise>                    
                </xsl:choose>
            </xsl:when>
            <!-- All other xref types -->
            <xsl:otherwise>
                <xsl:apply-templates mode="typesetting"/>               
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="fn-group" mode="typesetting">
        <xsl:if test="$FootnoteHandling='endnote'">
            <!-- to define -->
        </xsl:if> 
    </xsl:template>
     
    <!-- **********************************************************
         * Inline formats                                         *
         ********************************************************** -->

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

</xsl:stylesheet>
