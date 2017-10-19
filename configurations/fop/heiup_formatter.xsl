<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:rx="http://www.renderx.com/XSL/Extensions" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs" version="2.0">

    <!-- ****************************************************************** -->
    <!-- * HeiUP PDF Formatter for XSL FO 1.1                             * -->
    <!-- *                                           Not for production!  * -->
    <!-- ****************************************************************** -->
    <!-- 
           (Not yet) Published under Creative Commons License CC BY-NC-ND
           (https://creativecommons.org/licenses/by-nc-nd/4.0/)
     
           Frank Krabbes
           University Library Heidelberg, Publication Services
           Plöck 107-109, 69117 Heidelberg, Germany
           Mail to: krabbes at ub.uni-heidelberg.de
        
           (Any other XSLT 2.0 compliant processor can be used)
    -->

    <!-- ********************************************************** -->
    <!-- * Preamble: Variable definitions and include files       * -->
    <!-- ********************************************************** -->

    <!-- Definition of the output medium: Defines if PDF files optimized for print or electronic publishing are generated.
            values: 
                electronic : interactive version
                print      : print optimized version -->
    <xsl:param name="medium" as="xs:string" required="yes"/>

    <!-- Defines the renderer used: Defines if proprietary code will be generated.
            values: 
                FOP          : Fop 2.1 specific optimizations are included
                AntennaHouse : AntennaHouse 6.3 specific optimizations are included
                XEP          : XEP 4.25 specific optimizations are included -->
    <xsl:param name="formatter" as="xs:string" required="yes"/>

    <!-- Include template containing configuration, static text and styles -->
    <?include stylesheet?>
    <xsl:include href="template_heibooks_generic_m.xsl"/>

    <!-- ********************************************************** -->
    <!-- * Page formatting                                        * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="/">

        <!-- XEP specific code: Define PDF standard and include color profile -->
        <xsl:if test="$formatter = 'XEP'">
            <xsl:if test="$medium = 'electronic'">
                <!-- PDF Standard -->
                <xsl:processing-instruction name="xep-pdf-pdf-a">
                    <xsl:choose>
                        <xsl:when test="$Electronic_PDF_Standard = 'PDF/A-1a:2005'">
                            <xsl:text>pdf-a-1a</xsl:text>
                        </xsl:when>
                       <xsl:when test="$Electronic_PDF_Standard = 'PDF/A-1b:2005'">
                            <xsl:text>pdf-a-1b</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>pdf-a-1b</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:processing-instruction>
                <!-- ICC profile -->
                <xsl:processing-instruction name="xep-pdf-icc-profile">
                    <xsl:text>url('</xsl:text>
                    <xsl:value-of select="$ICC-Profile"/>
                    <xsl:text>')</xsl:text>
                </xsl:processing-instruction>
            </xsl:if>
            <xsl:if test="$medium = 'print'">
                <!-- PDF Standard -->
                <xsl:processing-instruction name="xep-pdf-pdf-x">
                    <xsl:choose>
                        <xsl:when test="($Print_PDF_Standard = 'PDF/X-1a:2001') or ($Print_PDF_Standard = 'PDF/X-1a:2003')">
                            <xsl:text>pdf-x-1a</xsl:text>
                        </xsl:when>
                        <xsl:when test="$Print_PDF_Standard = 'PDF/X-3:2002'">
                            <xsl:text>pdf-x-3</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>pdf-x-1a</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:processing-instruction>
                <!-- ICC profile -->
                <xsl:processing-instruction name="xep-pdf-icc-profile">
                    <xsl:text>url('</xsl:text>
                    <xsl:value-of select="$ICC-Profile"/>
                    <xsl:text>')</xsl:text>
                </xsl:processing-instruction>
            </xsl:if>
        </xsl:if>

        <fo:root>

            <!-- ********************************************************** -->
            <!-- * Page templates and page sequences                      * -->
            <!-- ********************************************************** -->

            <fo:layout-master-set>

                <!-- **********************************************************
                     * Page templates                                         *
                     ********************************************************** -->

                <!-- Cover pages -->

                <fo:simple-page-master master-name="cover-page">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <!-- no margins needed, cover images are inserted page filling -->
                    <xsl:attribute name="margin-left">0mm</xsl:attribute>
                    <xsl:attribute name="margin-right">0mm</xsl:attribute>
                    <xsl:attribute name="margin-top">0mm</xsl:attribute>
                    <xsl:attribute name="margin-bottom">0mm </xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>

                <!-- Frontmatter pages -->

                <fo:simple-page-master master-name="Frontmatter_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="Frontmatter_Verso">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>

                <!-- Table of contents pages -->

                <fo:simple-page-master master-name="ToC_First_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no running titles on first page of a ToC -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="ToC_First_Verso">
                    <!-- not really used -->
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no running titles on first page of a ToC -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="ToC_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="ToC_title_recto" extent="10mm"
                        display-align="before"/>
                    <fo:region-after extent="10mm" display-align="after"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="ToC_Verso">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="ToC_title_verso" extent="10mm"
                        display-align="before"/>
                    <fo:region-after extent="10mm" display-align="after"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="ToC_Last_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no page number on foot on last page -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="ToC_title_recto" extent="10mm"
                        display-align="before"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="ToC_Last_Verso">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no page number on foot on last page -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="ToC_title_verso" extent="10mm"
                        display-align="before"/>
                </fo:simple-page-master>

                <!-- Chapter title pages -->

                <fo:simple-page-master master-name="Chapter_First_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no running titles on first page of a chapter -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-after extent="10mm" display-align="after"
                        region-name="chapter_first_page_bottom"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="Chapter_First_Verso">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no running titles on first page of a chapter -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-after extent="10mm" display-align="after"
                        region-name="chapter_first_page_bottom"/>
                </fo:simple-page-master>

                <!-- Regular chapter pages -->
                <fo:simple-page-master master-name="Chapter_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="column_title_recto" extent="10mm"
                        display-align="before"/>
                    <fo:region-after extent="10mm" display-align="after"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="Chapter_Verso">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="column_title_verso" extent="10mm"
                        display-align="before"/>
                    <fo:region-after extent="10mm" display-align="after"/>
                </fo:simple-page-master>

                <!-- Chapter last pages -->
                <fo:simple-page-master master-name="Chapter_Last_Recto">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no page number on foot on last page -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="column_title_recto" extent="10mm"
                        display-align="before"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="Chapter_Last_Verso">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-left">
                        <xsl:value-of select="$MarginOuter"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-right">
                        <xsl:value-of select="$MarginInner"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-top">
                        <xsl:value-of select="$MarginTop"/>
                    </xsl:attribute>
                    <xsl:attribute name="margin-bottom">
                        <xsl:value-of select="$MarginBottom"/>
                    </xsl:attribute>
                    <!-- no page number on foot on last page -->
                    <fo:region-body margin-top="10mm" margin-bottom="10mm"/>
                    <fo:region-before region-name="column_title_verso" extent="10mm"
                        display-align="before"/>
                </fo:simple-page-master>

                <!-- Empty page -->
                <fo:simple-page-master master-name="Empty_Page">
                    <xsl:attribute name="page-height">
                        <xsl:value-of select="$PageHeight"/>
                    </xsl:attribute>
                    <xsl:attribute name="page-width">
                        <xsl:value-of select="$PageWidth"/>
                    </xsl:attribute>
                    <fo:region-body/>
                </fo:simple-page-master>

                <!-- **********************************************************
                     * Page sequences                                         *
                     ********************************************************** -->

                <!-- Cover -->
                <fo:page-sequence-master master-name="cover-sequence">
                    <fo:repeatable-page-master-alternatives maximum-repeats="1">
                        <fo:conditional-page-master-reference master-reference="cover-page"
                            odd-or-even="any" page-position="any" blank-or-not-blank="any"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

                <!-- Frontmatter -->
                <fo:page-sequence-master master-name="Frontmatter">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="Frontmatter_Recto"
                            page-position="first" odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="Frontmatter_Verso"
                            page-position="rest" odd-or-even="even"/>
                        <fo:conditional-page-master-reference master-reference="Frontmatter_Recto"
                            page-position="rest" odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="Frontmatter_Verso"
                            page-position="last" odd-or-even="even"/>
                        <fo:conditional-page-master-reference master-reference="Frontmatter_Recto"
                            page-position="last" odd-or-even="odd"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

                <!-- Table of Contents -->
                <fo:page-sequence-master master-name="ToC_Sequence">
                    <fo:repeatable-page-master-alternatives>
                        <!-- Firsts -->
                        <fo:conditional-page-master-reference page-position="first"
                            odd-or-even="odd" master-reference="ToC_First_Recto"/>
                        <fo:conditional-page-master-reference page-position="first"
                            odd-or-even="even" master-reference="ToC_First_Verso"/>
                        <!-- Rest of pages -->
                        <fo:conditional-page-master-reference page-position="rest" odd-or-even="odd"
                            master-reference="ToC_Recto"/>
                        <fo:conditional-page-master-reference page-position="rest"
                            odd-or-even="even" master-reference="ToC_Verso"/>
                        <!-- Last pages -->
                        <fo:conditional-page-master-reference page-position="last"
                            odd-or-even="even" blank-or-not-blank="blank"
                            master-reference="Empty_Page"/>
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="odd"
                            blank-or-not-blank="not-blank" master-reference="ToC_Last_Recto"/>
                        <fo:conditional-page-master-reference page-position="last"
                            odd-or-even="even" blank-or-not-blank="not-blank"
                            master-reference="ToC_Last_Verso"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

                <!-- Chapter pages -->
                <fo:page-sequence-master master-name="Chapter_Sequence">
                    <fo:repeatable-page-master-alternatives>
                        <!-- Firsts -->
                        <fo:conditional-page-master-reference page-position="first"
                            odd-or-even="odd" master-reference="Chapter_First_Recto"/>
                        <fo:conditional-page-master-reference page-position="first"
                            odd-or-even="even" master-reference="Chapter_First_Verso"/>
                        <!-- Rest of pages -->
                        <fo:conditional-page-master-reference page-position="rest" odd-or-even="odd"
                            master-reference="Chapter_Recto"/>
                        <fo:conditional-page-master-reference page-position="rest"
                            odd-or-even="even" master-reference="Chapter_Verso"/>
                        <!-- Last pages -->
                        <fo:conditional-page-master-reference page-position="last"
                            odd-or-even="even" blank-or-not-blank="blank"
                            master-reference="Empty_Page"/>
                        <fo:conditional-page-master-reference page-position="last" odd-or-even="odd"
                            blank-or-not-blank="not-blank" master-reference="Chapter_Last_Recto"/>
                        <fo:conditional-page-master-reference page-position="last"
                            odd-or-even="even" blank-or-not-blank="not-blank"
                            master-reference="Chapter_Last_Verso"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

            </fo:layout-master-set>

            <!-- ********************************************************** -->
            <!-- * FO Declarations                                        * -->
            <!-- ********************************************************** -->
            
            <fo:declarations>

                <!-- AntennaHouse specific code: PDF configuration -->
                <xsl:if test="$formatter = 'AntennaHouse'">

                    <xsl:if test="$medium = 'electronic'">
                        <!-- Embed color profiles -->
                        <fo:color-profile>
                            <xsl:attribute name="src">
                                <xsl:value-of select="$ICC-Profile"/>
                            </xsl:attribute>
                            <xsl:attribute name="color-profile-name">#RGB</xsl:attribute>
                        </fo:color-profile>
                    </xsl:if>

                    <axf:formatter-config xmlns:axs="http://www.antennahouse.com/names/XSL/Settings">
                        <xsl:choose>
                            <xsl:when test="$medium = 'electronic'">
                                <axs:pdf-settings tagged-pdf="true">
                                    <xsl:attribute name="tagged-pdf">true</xsl:attribute>
                                    <xsl:attribute name="pdf-version">
                                        <xsl:value-of select="$Electronic_PDF_Standard"/>
                                    </xsl:attribute>
                                </axs:pdf-settings>
                            </xsl:when>
                            <xsl:when test="$medium = 'print'">
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

                <!-- FOP specific code: Metadata inclusion -->
                <xsl:if test="$formatter = 'FOP'">
                    <x:xmpmeta xmlns:x="adobe:ns:meta/">
                        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                            <rdf:Description rdf:about=""
                                xmlns:dc="http://purl.org/dc/elements/1.1/">
                                <dc:title>
                                    <xsl:value-of
                                        select="/book/book-meta/book-title-group/book-title"/>
                                    <xsl:if test="/book/book-meta/book-title-group/subtitle">
                                        <xsl:text>. </xsl:text>
                                        <xsl:value-of
                                            select="/book/book-meta/book-title-group/subtitle"/>
                                    </xsl:if>
                                </dc:title>
                                <dc:creator>Document author</dc:creator>
                                <dc:description>Document subject</dc:description>
                                <dc:rights xml:lang="en">Published under CC-License.</dc:rights>
                            </rdf:Description>
                            <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
                                <!-- XMP properties go here -->
                                <!-- XMP documentation: http://www.adobe.com/devnet/xmp.html -->
                                <xmp:CreatorTool>mpt using FOP 2.1</xmp:CreatorTool>
                            </rdf:Description>
                            <rdf:Description rdf:about=""
                                xmlns:xmpRights="http://ns.adobe.com/xap/1.0/rights/">
                                <xmpRights:Marked>True</xmpRights:Marked>
                                <xmpRights:UsageTerms xml:lang="de">Publiziert unter
                                    CC-Lizenz.</xmpRights:UsageTerms>
                                <xmpRights:UsageTerms xml:lang="en">Published under
                                    CC-License.</xmpRights:UsageTerms>
                                <xmpRights:Owner>John Smith</xmpRights:Owner>
                                <xmpRights:WebStatement>https://creativecommons.org/licenses/</xmpRights:WebStatement>
                            </rdf:Description>
                        </rdf:RDF>
                    </x:xmpmeta>
                </xsl:if>

            </fo:declarations>

            <!-- ********************************************************** -->
            <!-- * PDF bookmark tree                                      * -->
            <!-- ********************************************************** -->
            
            <xsl:call-template name="pdf-bookmark-tree"/>
            
            <!-- ********************************************************** -->
            <!-- * Formatting of the Book                                 * -->
            <!-- ********************************************************** -->

            <!-- * Front cover ******************************************** -->
            
            <xsl:call-template name="front-cover"/>

            <!-- * Frontmatter ******************************************** -->

            <!-- Frontmatter -->
            <xsl:apply-templates select="/book/book-meta" mode="typesetting"/>

            <!-- Table of contents -->
            <xsl:call-template name="ToC"/>

            <!-- * Book body ********************************************* -->

            <xsl:apply-templates select="/book/book-body" mode="typesetting"/>

            <!-- * Book backmatter *************************************** -->

            <xsl:call-template name="book-backmatter"/>

            <!-- * Back cover ******************************************** -->

            <xsl:call-template name="back-cover"/>

        </fo:root>

    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Front and back cover in ePDF                           * -->
    <!-- ********************************************************** -->

    <!-- Front cover and front cover verso page -->
    <xsl:template name="front-cover">
        <xsl:if test="$medium='electronic' and $include-cover-images='true'">

            <!-- Front cover (U1) -->
            <fo:page-sequence master-reference="cover-sequence" initial-page-number="1" format="a">
                <fo:flow flow-name="xsl-region-body">
                    <xsl:element name="fo:block-container">
                        <xsl:attribute name="absolute-position">fixed</xsl:attribute>
                        <xsl:attribute name="top">0mm</xsl:attribute>
                        <xsl:attribute name="left">0mm</xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$PageWidth"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="$PageHeight"/>
                        </xsl:attribute>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="id">cover_1</xsl:attribute>
                            <xsl:element name="fo:external-graphic">
                                <xsl:attribute name="src">
                                    <!-- implement error handling if elements missing -->
                                    <xsl:text>url(</xsl:text>
                                    <xsl:value-of
                                        select="/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-front-outer']/@xlink:href"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="content-width">
                                    <xsl:value-of select="$PageWidth"/>
                                </xsl:attribute>
                                <xsl:attribute name="content-height">
                                    <xsl:value-of select="$PageHeight"/>
                                </xsl:attribute>
                                <xsl:if test="$formatter = 'XEP'">
                                    <xsl:attribute name="rx:alt-description">Front cover
                                        image</xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </fo:flow>
            </fo:page-sequence>

            <!-- Front cover back page (U2) -->
            <fo:page-sequence master-reference="cover-page" initial-page-number="2" format="a">
                <fo:flow flow-name="xsl-region-body">
                    <xsl:element name="fo:block-container">
                        <xsl:attribute name="absolute-position">fixed</xsl:attribute>
                        <xsl:attribute name="top">0mm</xsl:attribute>
                        <xsl:attribute name="left">0mm</xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$PageWidth"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="$PageHeight"/>
                        </xsl:attribute>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:if
                                test="/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-front-inner']">
                                <xsl:element name="fo:external-graphic">
                                    <xsl:attribute name="src">
                                        <xsl:text>url(</xsl:text>
                                        <xsl:value-of
                                            select="/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-front-inner']/@xlink:href"
                                        />
                                        <xsl:text>)</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="content-width">
                                        <xsl:value-of select="$PageWidth"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="content-height">
                                        <xsl:value-of select="$PageHeight"/>
                                    </xsl:attribute>
                                    <xsl:if test="$formatter = 'XEP'">
                                        <xsl:attribute name="rx:alt-description">Front cover
                                            backside</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </fo:flow>
            </fo:page-sequence>
        </xsl:if>
    </xsl:template>

    <!-- Back cover and back cover inner page -->
    <xsl:template name="back-cover">
        <xsl:if test="$medium='electronic' and $include-cover-images='true'">

            <!-- Back cover inner page (U3) -->
            <fo:page-sequence master-reference="cover-sequence" initial-page-number="3" format="a">
                <fo:flow flow-name="xsl-region-body">
                    <xsl:element name="fo:block-container">
                        <xsl:attribute name="absolute-position">fixed</xsl:attribute>
                        <xsl:attribute name="top">0mm</xsl:attribute>
                        <xsl:attribute name="left">0mm</xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$PageWidth"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="$PageHeight"/>
                        </xsl:attribute>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="color">white</xsl:attribute>
                            <xsl:if
                                test="/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-back-inner']">
                                <xsl:element name="fo:external-graphic">
                                    <xsl:attribute name="src">
                                        <!-- implement error handling if elements missing -->
                                        <xsl:text>url(</xsl:text>
                                        <xsl:value-of
                                            select="/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-back-inner']/@xlink:href"/>
                                        <xsl:text>)</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="content-width">
                                        <xsl:value-of select="$PageWidth"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="content-height">
                                        <xsl:value-of select="$PageHeight"/>
                                    </xsl:attribute>
                                    <xsl:if test="$formatter = 'XEP'">
                                        <xsl:attribute name="rx:alt-description">Back cover inner
                                            side</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if
                                test="(not(/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-back-inner'])) and ($formatter = 'XEP')">
                                <xsl:text>Page intentionally left blank.</xsl:text>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </fo:flow>
            </fo:page-sequence>

            <!-- Back cover outer page (U4) -->
            <fo:page-sequence master-reference="cover-page" initial-page-number="4" format="a">
                <fo:flow flow-name="xsl-region-body">
                    <xsl:element name="fo:block-container">
                        <xsl:attribute name="absolute-position">fixed</xsl:attribute>
                        <xsl:attribute name="top">0mm</xsl:attribute>
                        <xsl:attribute name="left">0mm</xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$PageWidth"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="$PageHeight"/>
                        </xsl:attribute>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="id">cover_4</xsl:attribute>
                            <xsl:element name="fo:external-graphic">
                                <xsl:attribute name="src">
                                    <xsl:text>url(</xsl:text>
                                    <xsl:value-of
                                        select="/book/book-meta/supplementary-material/graphic[@content-type = 'cover-image-back-outer']/@xlink:href"
                                    />
                                    <xsl:text>)</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="content-width">
                                    <xsl:value-of select="$PageWidth"/>
                                </xsl:attribute>
                                <xsl:attribute name="content-height">
                                    <xsl:value-of select="$PageHeight"/>
                                </xsl:attribute>
                                <xsl:if test="$formatter = 'XEP'">
                                    <xsl:attribute name="rx:alt-description">Back cover
                                        image</xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </fo:flow>
            </fo:page-sequence>
        </xsl:if>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Book frontmatter formatting                            * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="book-meta" mode="typesetting">
        <fo:page-sequence master-reference="Frontmatter" initial-page-number="1" format="1">
            <!-- roman page numbers not supported yet -->
            <fo:flow flow-name="xsl-region-body">

                <!-- Half title -->
                <xsl:element name="fo:block" use-attribute-sets="half-title fonts_regular_text">
                    <xsl:attribute name="page-break-after">always</xsl:attribute>
                    <xsl:attribute name="id">half-title</xsl:attribute>
                    <xsl:apply-templates select="book-title-group/book-title"/>
                </xsl:element>

                <!-- Series title / Half title verso page -->
                <xsl:choose>
                    <xsl:when test="preceding-sibling::collection-meta and $series_title_page='yes'">
                        <xsl:element name="fo:block-container" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="page-break-after">always</xsl:attribute>
                            <xsl:attribute name="id">series-title</xsl:attribute>
                            <!-- Main title -->
                            <xsl:element name="fo:block" use-attribute-sets="series_title_main_title_format">
                                <xsl:apply-templates select="../collection-meta/title-group/title" mode="series-title"/>
                            </xsl:element>
                            <!-- Subtitle -->
                            <xsl:if test="../collection-meta/title-group/subtitle">
                                <xsl:element name="fo:block" use-attribute-sets="series_title_subtitle_format">
                                    <xsl:apply-templates select="../collection-meta/title-group/subtitle" mode="series-title"/>
                                </xsl:element>
                            </xsl:if>
                            <!-- Series editors -->
                            <xsl:choose>
                                <xsl:when test="ancestor::book/@xml:lang='de'">
                                    <xsl:if test="not($series_edited_by_de='')">
                                        <xsl:element name="fo:block" use-attribute-sets="series_title_editors_format">
                                            <xsl:value-of select="$series_edited_by_de"/>
                                        </xsl:element>
                                        <xsl:element name="fo:block" use-attribute-sets="series_title_editors_format">
                                            <xsl:for-each select="../collection-meta/contrib-group/contrib[@contrib-type = 'series-editor']">
                                                <xsl:if test="(position() != 1) and (position() &lt; last())">
                                                    <xsl:value-of select="$series_edited_name_divider"/>
                                                </xsl:if>
                                                <xsl:if test="position() = last()">
                                                    <xsl:value-of select="$series_edited_name_divider_last_de"/>
                                                </xsl:if>
                                                <xsl:value-of select="name/given-names"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="name/surname"/>
                                            </xsl:for-each>
                                        </xsl:element>                                        
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="not($series_edited_by_de='')">
                                        <xsl:element name="fo:block" use-attribute-sets="series_title_editors_format">
                                            <xsl:value-of select="$series_edited_by_en"/>
                                        </xsl:element>
                                        <xsl:element name="fo:block" use-attribute-sets="series_title_editors_format">
                                            <xsl:for-each select="../collection-meta/contrib-group/contrib[@contrib-type = 'series-editor']">
                                                <xsl:if test="(position() != 1) and (position() &lt; last())">
                                                    <xsl:value-of select="$series_edited_name_divider"/>
                                                </xsl:if>
                                                <xsl:if test="position() = last()">
                                                    <xsl:value-of select="$series_edited_name_divider_last_en"/>
                                                </xsl:if>
                                                <xsl:value-of select="name/given-names"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="name/surname"/>
                                            </xsl:for-each>
                                        </xsl:element>                                        
                                    </xsl:if>                                    
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- Volume number -->
                            <xsl:element name="fo:block" use-attribute-sets="series_title_volume_number_format">
                                <xsl:choose>
                                    <xsl:when test="ancestor::book/@xml:lang='de'">
                                        <xsl:value-of select="$series_title_volume_number_prefix_de"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$series_title_volume_number_prefix_en"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates select="../collection-meta/volume-in-collection/volume-number" mode="typesetting"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="page-break-after">always</xsl:attribute>
                            <xsl:attribute name="id">series-title</xsl:attribute>
                            <xsl:choose>
                                <!-- Special treatment for XEP here. XEP does not create a blank page with no contents -->
                                <xsl:when test="$formatter = 'XEP' or $formatter = 'FOP'">
                                    <xsl:attribute name="color">#FFFFFF</xsl:attribute>
                                    <xsl:text>This page is intentionally left blank</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- Main title -->

                <!-- Logo placement -->
                <xsl:element name="fo:block-container">
                    <xsl:attribute name="absolute-position">fixed</xsl:attribute>
                    <xsl:attribute name="top">
                        <xsl:value-of select="$pub-logo-main-title-ypos"/>
                    </xsl:attribute>
                    <xsl:attribute name="left">
                        <xsl:value-of select="$pub-logo-main-title-xpos"/>
                    </xsl:attribute>
                    <xsl:attribute name="width">
                        <xsl:value-of select="$pub-logo-main-title-width"/>
                    </xsl:attribute>
                    <xsl:attribute name="height">
                        <xsl:value-of select="$pub-logo-main-title-height"/>
                    </xsl:attribute>
                    <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                        <xsl:element name="fo:external-graphic">
                            <xsl:attribute name="src">
                                <xsl:text>url(</xsl:text>
                                <xsl:value-of select="$pub-logo-main-title-fileref"/>
                                <xsl:text>)</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="content-width">
                                <xsl:value-of select="$pub-logo-main-title-width"/>
                            </xsl:attribute>
                            <xsl:attribute name="content-height">
                                <xsl:value-of select="$pub-logo-main-title-height"/>
                            </xsl:attribute>
                            <xsl:if test="$formatter = 'XEP'">
                                <xsl:attribute name="rx:alt-description">Publisher
                                    logo</xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <!-- content -->
                <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                    <xsl:attribute name="page-break-after">always</xsl:attribute>
                    <xsl:attribute name="id">main-title</xsl:attribute>
                    <xsl:text>main title page</xsl:text>
                </xsl:element>

                <!-- Impressum / main title verso page -->
                <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                    <xsl:attribute name="id">impressum</xsl:attribute>
                    <xsl:text>Impressum</xsl:text>
                </xsl:element>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Book backmatter formatting                             * -->
    <!-- ********************************************************** -->
    
    <xsl:template name="book-backmatter">

        <!-- Endnotes in book backmatter -->
        <xsl:if test="$FootnoteHandling = 'endnote_book_backmatter'">
            <xsl:call-template name="endnotes-book-backmatter"/>
        </xsl:if>

    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Part formatting                                        * -->
    <!-- ********************************************************** -->
        
    <xsl:template match="book-body" mode="typesetting">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <xsl:template match="book-part" mode="typesetting">

        <!-- Book part -->
        
            <!-- Not implemented yet -->
        
        <!-- Book part: Chapters -->

        <fo:page-sequence master-reference="Chapter_Sequence" id="{generate-id(.)}">
            <!-- defines if chapters have an even page count or not -->
            <xsl:attribute name="force-page-count">
                <xsl:choose>
                    <xsl:when test="following-sibling::book-part">
                        <xsl:value-of select="$ChapterPageHandling"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>end-on-even</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- Footnote separator -->
            <xsl:if test="$footnote-separator = 'yes'">
                <fo:static-content flow-name="xsl-footnote-separator">
                    <fo:block text-align-last="justify">
                        <xsl:element name="fo:leader" use-attribute-sets="footnote_sep"/>
                    </fo:block>
                </fo:static-content>
            </xsl:if>

            <!-- Running headers -->
            <!-- Running header on left page -->
            <fo:static-content flow-name="column_title_verso">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_verso">
                    <fo:page-number/>
                    <xsl:text> – </xsl:text>
                    <fo:retrieve-marker retrieve-boundary="document"
                        retrieve-class-name="running_head_left"/>
                </xsl:element>
            </fo:static-content>
            <!-- Running header on right page -->
            <fo:static-content flow-name="column_title_recto">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_recto">
                    <fo:retrieve-marker retrieve-boundary="document"
                        retrieve-class-name="running_head_right"/>
                    <xsl:text> – </xsl:text>
                    <fo:page-number/>
                </xsl:element>
            </fo:static-content>

            <!-- DOI and URN on first page -->
            <fo:static-content flow-name="chapter_first_page_bottom">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-headings">
                    <fo:retrieve-marker retrieve-boundary="document" retrieve-class-name="doi"/>
                </xsl:element>
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-headings">
                    <fo:retrieve-marker retrieve-boundary="document" retrieve-class-name="urn"/>
                </xsl:element>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body">
                <xsl:apply-templates mode="typesetting"/>
            </fo:flow>

        </fo:page-sequence>

    </xsl:template>

    <xsl:template match="book-part-meta" mode="typesetting">
        <xsl:choose>
            <xsl:when test="/book[@book-type = 'monograph']">
                <xsl:apply-templates select="title-group" mode="chapter-title"/>
            </xsl:when>
            <xsl:when test="/book[@book-type = 'proceedings']">
                <xsl:apply-templates select="contrib-group" mode="proceedings"/>
                <xsl:apply-templates select="title-group" mode="chapter-title"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="body" mode="typesetting">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <xsl:template match="back" mode="typesetting">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * First Page of a book part                              * -->
    <!-- ********************************************************** -->

    <!-- First page of a chapter in a monograph -->
    <xsl:template match="title-group" mode="chapter-title">

        <xsl:element name="fo:block-container" use-attribute-sets="margin_under_title">
            <xsl:if test="not(/book[@book-type = 'proceedings'])">
                <xsl:attribute name="id">
                    <xsl:value-of select="ancestor::book-part[1]/@id"/>
                </xsl:attribute>
            </xsl:if>
            
            <!-- DOI and URN -->
            <xsl:if test="($medium = 'electronic' and $display_doi_monograph_first_page = 'electronic') or ($medium = 'print' and $display_doi_monograph_first_page = 'print') or ($display_doi_monograph_first_page = 'both')">
                <xsl:if test="../custom-meta-group/custom-meta[@specific-use = 'doi']">
                    <fo:marker marker-class-name="doi">
                        <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'doi']/meta-name"/>
                        <xsl:text>: </xsl:text>
                        <xsl:choose>
                            <xsl:when test="$medium = 'electronic'">
                                <xsl:element name="fo:basic-link" use-attribute-sets="hyperlink">
                                    <xsl:attribute name="external-destination">
                                        <xsl:text>url(http://dx.doi.org/</xsl:text>
                                            <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'doi']/meta-value"/>
                                        <xsl:text>)</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>
                                <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'doi']/meta-value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'doi']/meta-value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:marker>
                </xsl:if>
            </xsl:if>
            <xsl:if test="($medium = 'electronic' and $display_urn_monograph_first_page = 'electronic') or ($medium = 'print' and $display_urn_monograph_first_page = 'print') or ($display_urn_monograph_first_page = 'both')">
                <xsl:if test="../custom-meta-group/custom-meta[@specific-use = 'urn']">
                    <fo:marker marker-class-name="urn">
                        <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'urn']/meta-name"/>
                        <xsl:text>: </xsl:text>
                        <xsl:choose>
                            <xsl:when test="$medium = 'electronic'">
                                <xsl:element name="fo:basic-link" use-attribute-sets="hyperlink">
                                    <xsl:attribute name="external-destination">
                                        <xsl:text>url(https://nbn-resolving.org/resolver?identifier=</xsl:text>
                                            <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'urn']/meta-value"/>
                                        <xsl:text>)</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>
                                <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'urn']/meta-value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="../custom-meta-group/custom-meta[@specific-use = 'urn']/meta-value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:marker>
                </xsl:if>
            </xsl:if>

            <!-- Running Header Even Page: Title -->
            <fo:marker marker-class-name="running_head_left">
                <xsl:if test="label">
                    <xsl:apply-templates select="label" mode="typesetting"/>
                    <xsl:text>&#x2002;</xsl:text>
                </xsl:if>
                <xsl:apply-templates select="title" mode="typesetting"/>
            </fo:marker>
            <xsl:element name="fo:block" use-attribute-sets="fonts_chapter_title do_not_hyphenate keeps-headings">
                <xsl:if test="label">
                    <xsl:apply-templates select="label" mode="typesetting"/>
                    <xsl:text>&#x2002;</xsl:text>
                </xsl:if>
                <xsl:apply-templates select="title" mode="monograph_chapter_title"/>
                <xsl:apply-templates select="subtitle" mode="chapter_title"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Display author names (proceedings only) -->
    <xsl:template match="contrib-group" mode="proceedings">
        <xsl:element name="fo:block"
            use-attribute-sets="fonts_author_names_chapter_head keeps-headings">
            <xsl:attribute name="id">
                <xsl:value-of select="ancestor::book-part[1]/@id"/>
            </xsl:attribute>
            <!-- Running Header Left -->
            <fo:marker marker-class-name="running_head_left">
                <xsl:for-each select="contrib[@contrib-type = 'author']">
                    <xsl:choose>
                        <xsl:when test="position() &lt;= $Proceedings_Max_Authors_Running_Head_Left">
                            <xsl:if test="position() != 1">
                                <xsl:value-of
                                    select="$Proceedings_Authors_Running_Head_Left_Divider"/>
                            </xsl:if>
                            <xsl:value-of select="name/given-names"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="name/surname"/>
                        </xsl:when>
                        <xsl:when
                            test="position() = ($Proceedings_Max_Authors_Running_Head_Left + 1)">
                            <xsl:value-of select="$Proceedings_Authors_Running_Head_Left_etal"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </fo:marker>
            <!-- Display as text -->
            <xsl:for-each select="contrib[@contrib-type = 'author']">
                <xsl:if test="position() != 1">
                    <xsl:value-of select="$author-name-divider_chapter-head"/>
                </xsl:if>
                <xsl:value-of select="name/given-names"/>
                <xsl:text>&#x00A0;</xsl:text>
                <!-- Non breaking space to keep author names together -->
                <xsl:value-of select="name/surname"/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Titles and Headings                                    * -->
    <!-- ********************************************************** -->
    
    <!-- Series title on series title page -->
    <xsl:template match="title" mode="series-title">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <!-- Series subitle on series title page -->
    <xsl:template match="subtitle" mode="series-title">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>   

    <!-- Chapter title -->
    <xsl:template match="title" mode="monograph_chapter_title">
         <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <!-- Chapter subtitle -->
    <xsl:template match="subtitle" mode="chapter_title">
        <xsl:element name="fo:block" use-attribute-sets="fonts_chapter_subtitle keeps-headings">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <!-- Headings -->
    <xsl:template match="title" mode="typesetting">
        <!-- Parent elements: app, boxed-text, sec -->
        <!-- Retrieve the hierarchy level of the heading -->
        <xsl:variable name="hierarchy_level">
            <xsl:value-of select="count(ancestor::sec)"/>
        </xsl:variable>

        <xsl:if test="parent::title-group">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:if>

        <xsl:if test="parent::sec">
            <xsl:choose>
                <xsl:when test="(($hierarchy_level = 1) and (/book[@book-type = 'monograph']))">
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_1 keeps-headings">
                        <xsl:attribute name="id">
                            <xsl:value-of select="../@id"/>
                        </xsl:attribute>
                        <!-- Right header: First section header -->
                        <fo:marker marker-class-name="running_head_right">
                            <xsl:if test="preceding-sibling::label">
                                <xsl:apply-templates select="preceding-sibling::label"
                                    mode="heading"/>
                                <xsl:text>&#x2002;</xsl:text>
                            </xsl:if>
                            <xsl:apply-templates mode="typesetting"/>
                        </fo:marker>
                        <xsl:if test="preceding-sibling::label">
                            <xsl:apply-templates select="preceding-sibling::label" mode="heading"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="(($hierarchy_level = 1) and not(/book[@book-type = 'monograph']))">
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_1 keeps-headings">
                        <xsl:attribute name="id">
                            <xsl:value-of select="../@id"/>
                        </xsl:attribute>
                        <xsl:if test="preceding-sibling::label">
                            <xsl:apply-templates select="preceding-sibling::label" mode="heading"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$hierarchy_level = 2">
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_2 keeps-headings">
                        <xsl:attribute name="id">
                            <xsl:value-of select="../@id"/>
                        </xsl:attribute>
                        <xsl:if test="preceding-sibling::label">
                            <xsl:apply-templates select="preceding-sibling::label" mode="heading"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$hierarchy_level = 3">
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_3 keeps-headings">
                        <xsl:attribute name="id">
                            <xsl:value-of select="../@id"/>
                        </xsl:attribute>
                        <xsl:if test="preceding-sibling::label">
                            <xsl:apply-templates select="preceding-sibling::label" mode="heading"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$hierarchy_level = 4">
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_4 keeps-headings">
                        <xsl:attribute name="id">
                            <xsl:value-of select="../@id"/>
                        </xsl:attribute>
                        <xsl:if test="preceding-sibling::label">
                            <xsl:apply-templates select="preceding-sibling::label" mode="heading"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$hierarchy_level &gt; 4">
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_4 keeps-headings">
                        <xsl:attribute name="id">
                            <xsl:value-of select="../@id"/>
                        </xsl:attribute>
                        <xsl:if test="preceding-sibling::label">
                            <xsl:apply-templates select="preceding-sibling::label" mode="heading"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Labels and chapter numbering -->
    <xsl:template match="label" mode="heading">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <!-- Heading of the endnote section at the end of the book and bibliography -->
    <xsl:template match="title" mode="endnote_heading">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>
    
    <!-- ********************************************************** -->
    <!-- * Paragraphs                                             * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="p" mode="typesetting">
        <xsl:choose>
            <xsl:when test="parent::fn">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text paragraph_formats hyphenate keeps-paragraph no_indents-paragraph_first_line">
                    <!-- Insert Footnote label into the first paragraph -->
                    <xsl:if test="not(./preceding-sibling::p)">
                        <xsl:variable name="footnote_id" select="ancestor::fn/@id"/>
                        <xsl:choose>
                            <!-- Hyperlink for electronic PDF -->
                            <xsl:when test="$medium = 'electronic'">
                                <xsl:element name="fo:inline" use-attribute-sets="hyperlink">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="ancestor::fn/@id"/>
                                    </xsl:attribute>
                                    <xsl:variable name="backlink">
                                        <xsl:value-of select="$footnote_id"/>
                                        <xsl:text>_backlink</xsl:text>
                                    </xsl:variable>
                                    <fo:basic-link internal-destination="{$backlink}">
                                        <xsl:value-of
                                            select="/descendant::xref[@rid = $footnote_id]"/>
                                    </fo:basic-link>
                                    <xsl:text>&#x2002;</xsl:text>
                                </xsl:element>
                            </xsl:when>
                            <!-- Text only in the non electronic PDF -->
                            <xsl:otherwise>
                                <fo:inline>
                                    <xsl:value-of select="/descendant::xref[@rid = $footnote_id]"/>
                                    <xsl:text>&#x2002;</xsl:text>
                                </fo:inline>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="parent::disp-quote">
                <!--<xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][self::p]">
                        <xsl:element name="fo:block"
                            use-attribute-sets="indents-disp-quote_first_line">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>-->
                <xsl:element name="fo:block">
                    <xsl:apply-templates mode="typesetting"/>
                </xsl:element>
                <!--   </xsl:otherwise>
                </xsl:choose>-->
            </xsl:when>
            <xsl:when test="(ancestor::table-wrap) or (ancestor::fig)">
                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::*[1][self::p])">
                        <xsl:element name="fo:block"
                            use-attribute-sets="fonts_petit_text paragraph_formats hyphenate keeps-paragraph">
                            <xsl:element name="fo:inline" use-attribute-sets="caption_labels">
                                <xsl:apply-templates select="../../label"/>
                                <xsl:text>. </xsl:text>
                            </xsl:element>
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block"
                            use-attribute-sets="fonts_petit_text paragraph_formats hyphenate keeps-paragraph">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][self::p]">
                        <xsl:element name="fo:block"
                            use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph indents-paragraph_first_line">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block"
                            use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph no_indents-paragraph_first_line">
                            <xsl:apply-templates mode="typesetting"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Cross references to footnotes, figures, tables etc.    * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="xref" mode="typesetting">
        <xsl:choose>
            
            <!-- Footnotes -->
            <xsl:when test="(@ref-type = 'fn')">
                <!-- Check if footnotes should be treated as foot- or endnotes -->
                <xsl:if test="$FootnoteHandling = 'footnote'">
                    <xsl:variable name="fn_id" select="@rid"/>
                    <fo:footnote>
                        <xsl:choose>
                            <xsl:when test="$medium = 'electronic'">
                                <xsl:element name="fo:inline"
                                    use-attribute-sets="footnote_reference_number hyperlink">
                                    <xsl:attribute name="id">
                                        <xsl:variable name="backlink">
                                            <xsl:value-of select="@rid"/>
                                            <xsl:text>_backlink</xsl:text>
                                        </xsl:variable>
                                        <xsl:value-of select="$backlink"/>
                                    </xsl:attribute>
                                    <fo:basic-link internal-destination="{@rid}">
                                        <xsl:apply-templates mode="typesetting"/>
                                    </fo:basic-link>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="fo:inline"
                                    use-attribute-sets="footnote_reference_number">
                                    <xsl:apply-templates mode="typesetting"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <fo:footnote-body start-indent="0em" end-indent="0em">
                            <xsl:apply-templates
                                select="//ancestor::book-part/back/fn-group/fn[@id = $fn_id]"
                                mode="typesetting"/>
                        </fo:footnote-body>
                    </fo:footnote>
                </xsl:if>
                <!-- for endnotes only the reference number is printed in the text -->
                <xsl:if
                    test="($FootnoteHandling = 'endnote_chapter_backmatter') or ($FootnoteHandling = 'endnote_book_backmatter')">
                    <xsl:choose>
                        <xsl:when test="$medium = 'electronic'">
                            <xsl:element name="fo:inline"
                                use-attribute-sets="footnote_reference_number hyperlink">
                                <xsl:attribute name="id">
                                    <xsl:variable name="backlink">
                                        <xsl:value-of select="@rid"/>
                                        <xsl:text>_backlink</xsl:text>
                                    </xsl:variable>
                                    <xsl:value-of select="$backlink"/>
                                </xsl:attribute>
                                <fo:basic-link internal-destination="{@rid}">
                                    <xsl:apply-templates mode="typesetting"/>
                                </fo:basic-link>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="fo:inline"
                                use-attribute-sets="footnote_reference_number">
                                <xsl:apply-templates mode="typesetting"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
 
            <!-- All other xref types -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$medium = 'electronic'">
                        <xsl:element name="fo:inline" use-attribute-sets="hyperlink">
                            <fo:basic-link internal-destination="{@rid}">
                                <xsl:apply-templates mode="typesetting"/>
                            </fo:basic-link>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Bibliography and references                            * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="ref-list" mode="typesetting">
        
        <!-- Heading -->
        <xsl:variable name="hierarchy_level">
            <xsl:value-of select="count(ancestor::ref-list)"/>
        </xsl:variable>

        <!-- If there is a title insert title -->
        <xsl:if test="./title">
            <xsl:if test="$hierarchy_level=0">
                <xsl:element name="fo:block" use-attribute-sets="fonts_heading_1 keeps-headings">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:if test="./label">
                        <xsl:apply-templates select="./label" mode="heading"/>
                        <xsl:text>&#x2002;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="./title" mode="endnote_heading"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="$hierarchy_level=1">
                <xsl:element name="fo:block" use-attribute-sets="fonts_heading_2 keeps-headings">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:if test="./label">
                        <xsl:apply-templates select="./label" mode="heading"/>
                        <xsl:text>&#x2002;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="./title" mode="endnote_heading"/>
                </xsl:element>                
            </xsl:if>
        </xsl:if>
        
        <xsl:apply-templates select="ref | ref-list" mode="typesetting"/>
    
    </xsl:template>
    
    <xsl:template match="ref" mode="typesetting">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][self::ref]">
                <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph no_indents_bibliographic_entry">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:if test="./label">
                        <fo:inline>
                            <xsl:apply-templates select="./label"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </fo:inline>
                    </xsl:if>
                    <xsl:apply-templates select="mixed-citation" mode="typesetting"/>        
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text paragraph_formats hyphenate keeps-paragraph indents_bibliographic_entry">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:if test="./label">
                        <fo:inline>
                            <xsl:apply-templates select="./label"/>
                            <xsl:text>&#x2002;</xsl:text>
                        </fo:inline>
                    </xsl:if>
                    <xsl:apply-templates select="mixed-citation" mode="typesetting"/>        
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="mixed-citation" mode="typesetting">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>
 
    <!-- ********************************************************** -->
    <!-- * Endnotes                                               * -->
    <!-- ********************************************************** -->

    <!-- Endnotes in chapter backmatter -->
    <xsl:template match="fn-group" mode="typesetting">
        <xsl:if test="$FootnoteHandling = 'endnote_chapter_backmatter'">
            <xsl:element name="fo:block" use-attribute-sets="fonts_heading_1 keeps-headings">
                <xsl:attribute name="id">
                    <xsl:value-of select="ancestor::book-part[1]/@id"/>
                    <xsl:text>_chap_endnotes</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="ancestor::book-part[@xml:lang = 'de']">
                        <xsl:value-of select="$heading_endnotes_chapter_backmatter_de"/>
                    </xsl:when>
                    <!-- Default: English -->
                    <xsl:otherwise>
                        <xsl:value-of select="$heading_endnotes_chapter_backmatter_en"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:for-each select="fn">
                <xsl:apply-templates mode="typesetting"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- Endnotes in book backmatter -->
    <xsl:template name="endnotes-book-backmatter">

        <fo:page-sequence master-reference="Chapter_Sequence" id="{generate-id(.)}">

            <!-- defines if chapters have an even page count or not -->
            <xsl:attribute name="force-page-count">
                <xsl:choose>
                    <xsl:when test="following-sibling::book-part">
                        <xsl:value-of select="$ChapterPageHandling"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>end-on-even</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- Footnote separator -->
            <xsl:if test="$footnote-separator = 'yes'">
                <fo:static-content flow-name="xsl-footnote-separator">
                    <fo:block text-align-last="justify">
                        <xsl:element name="fo:leader" use-attribute-sets="footnote_sep"/>
                    </fo:block>
                </fo:static-content>
            </xsl:if>

            <!-- Running headers -->
            <fo:static-content flow-name="column_title_verso">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_verso">
                    <fo:page-number/>
                    <xsl:text> – </xsl:text>
                    <fo:retrieve-marker retrieve-boundary="document"
                        retrieve-class-name="running_head_left"/>
                </xsl:element>
            </fo:static-content>
            <fo:static-content flow-name="column_title_recto">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_recto">
                    <fo:retrieve-marker retrieve-boundary="document"
                        retrieve-class-name="running_head_right"/>
                    <xsl:text> – </xsl:text>
                    <fo:page-number/>
                </xsl:element>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body">

                <!-- Heading -->
                <xsl:element name="fo:block" use-attribute-sets="fonts_chapter_title keeps-headings">
                    <xsl:attribute name="id">
                        <xsl:text>book_endnotes</xsl:text>
                    </xsl:attribute>
                    
                    <!-- fill running head -->
                    <fo:marker marker-class-name="running_head_left">
                        <xsl:choose>
                            <xsl:when test="/book[@xml:lang = 'de']">
                                <xsl:value-of select="$heading_endnotes_chapter_backmatter_de"/>
                            </xsl:when>
                            <!-- Default: English -->
                            <xsl:otherwise>
                                <xsl:value-of select="$heading_endnotes_chapter_backmatter_en"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:marker>
                    <fo:marker marker-class-name="running_head_right">
                        <xsl:choose>
                            <xsl:when test="/book[@xml:lang = 'de']">
                                <xsl:value-of select="$heading_endnotes_chapter_backmatter_de"/>
                            </xsl:when>
                            <!-- Default: English -->
                            <xsl:otherwise>
                                <xsl:value-of select="$heading_endnotes_chapter_backmatter_en"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:marker>

                    <!-- Text in flow -->
                    <xsl:choose>
                        <xsl:when test="/book[@xml:lang = 'de']">
                            <xsl:value-of select="$heading_endnotes_chapter_backmatter_de"/>
                        </xsl:when>
                        <!-- Default: English -->
                        <xsl:otherwise>
                            <xsl:value-of select="$heading_endnotes_chapter_backmatter_en"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>

                <!-- Chapter footnotes -->
                <xsl:for-each select="/book/book-body/book-part/back/fn-group">

                    <!-- Insert heading -->
                    <xsl:element name="fo:block" use-attribute-sets="fonts_heading_1 keeps-headings">
                        <xsl:apply-templates
                            select="ancestor::book-part//book-part-meta/title-group/title"
                            mode="endnote_heading"/>
                    </xsl:element>

                    <!-- Insert endnotes -->
                    <xsl:apply-templates select="fn" mode="typesetting"/>
                </xsl:for-each>

            </fo:flow>

        </fo:page-sequence>

    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Block quotes                                           * -->
    <!-- ********************************************************** -->

    <xsl:template match="disp-quote" mode="typesetting">
        <xsl:element name="fo:block"
            use-attribute-sets="fonts_petit_text hyphenate keeps-paragraph paragraph_formats indents-disp-quote">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Verse (poem)                                           * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="verse-group" mode="typesetting">
        <xsl:element name="fo:block" use-attribute-sets="verse-group do_not_hyphenate">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="verse-line" mode="typesetting">
        <xsl:element name="fo:block">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Lists                                                  * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="list" mode="typesetting">
        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
            <xsl:element name="fo:list-block" use-attribute-sets="ul_1_block-level">
                <xsl:apply-templates select="list-item" mode="typesetting"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="list-item" mode="typesetting">
        <xsl:element name="fo:list-item">
            <fo:list-item-label end-indent="label-end()">
                <xsl:choose>
                    <xsl:when test="../@list-type='bullet'">
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:value-of select="$ul_symbol"/>
                        </xsl:element>                        
                    </xsl:when>
                    <xsl:when test="../@list-type='order'">
                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:apply-templates select="label"/>
                        </xsl:element>                        
                    </xsl:when>
                </xsl:choose>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <xsl:apply-templates select="* except(label)" mode="typesetting"/>
            </fo:list-item-body>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Figures                                                * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="fig" mode="typesetting">
        <xsl:choose>
            <xsl:when test="@position='float'">
                
                <!-- FOP 2.1: use fo:block instead of fo:float -->
                <xsl:choose>
                    <xsl:when test="$formatter = 'FOP'">
                        <!-- To do: Block container with height and width given -->
                        <xsl:element name="fo:block" use-attribute-sets="fonts_petit_text">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@id"/>
                            </xsl:attribute>
                            <xsl:attribute name="space-before">
                                <xsl:value-of select="$LineGridPetit"/>
                            </xsl:attribute>
                            <xsl:attribute name="space-after">
                                <xsl:value-of select="$LineGridPetit"/>
                            </xsl:attribute>
                            
                            <xsl:choose>
                                <xsl:when test="$medium = 'electronic'">
                                    <xsl:apply-templates select="graphic[@specific-use='electronic']" mode="typesetting"/>
                                </xsl:when>
                                <xsl:when test="$medium = 'print'">
                                    <xsl:apply-templates select="graphic[@specific-use='print']" mode="typesetting"/>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:apply-templates select="caption" mode="typesetting"/>                        
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- XEP and AH code -->
                        <xsl:element name="fo:float">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@id"/>
                            </xsl:attribute>
                            <xsl:attribute name="float">before</xsl:attribute>
                            
                            <!-- formatter specific code 
                            <xsl:if test="$formatter='AntennaHouse'">
                                <xsl:attribute name="float">before</xsl:attribute>
                                <xsl:attribute name="axf:float-wrap">wrap</xsl:attribute>
                                <xsl:attribute name="axf:float-move">auto-next</xsl:attribute>
                                <xsl:attribute name="axf:float-x">none</xsl:attribute>
                                <xsl:attribute name="axf:float-y">top</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$formatter='XEP'">
                                <xsl:attribute name="float">before</xsl:attribute>
                            </xsl:if>-->
                            
                            <xsl:element name="fo:block-container">
                                <xsl:attribute name="width">
                                    <xsl:value-of select="$ColumnWidth"/>
                                </xsl:attribute>
                                <xsl:attribute name="height">
                                    <xsl:value-of select="$ColumnHeight"/>
                                </xsl:attribute>
                                
                                <xsl:choose>
                                    <xsl:when test="$medium = 'electronic'">
                                        <xsl:apply-templates select="graphic[@specific-use='electronic']" mode="typesetting"/>
                                    </xsl:when>
                                    <xsl:when test="$medium = 'print'">
                                        <xsl:apply-templates select="graphic[@specific-use='print']" mode="typesetting"/>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:apply-templates select="caption" mode="typesetting"/>                            
                            
                            </xsl:element>
                            
                        </xsl:element>
                    </xsl:otherwise>               
                </xsl:choose>                        
            </xsl:when>
            <xsl:otherwise>
                <!-- .. -->
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="graphic" mode="typesetting">
        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
            <xsl:element name="fo:external-graphic">
                <xsl:attribute name="src">
                    <!-- implement error handling if elements missing -->
                    <xsl:text>url(</xsl:text>
                    <xsl:value-of select="@xlink:href"/>
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
                <xsl:if test="$formatter = 'XEP'">
                    <xsl:attribute name="rx:alt-description">image</xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:element>
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
            <xsl:choose>
                <xsl:when test="not(child::tbody)">
                    <xsl:element name="fo:table-body">
                        <xsl:apply-templates mode="typesetting"/>
                    </xsl:element>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="typesetting"/>                    
                </xsl:otherwise>
            </xsl:choose>
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
            <xsl:element name="fo:block"
                use-attribute-sets="fonts_petit_text keeps-paragraph hyphenate">
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
        <xsl:if test="not(ancestor::table-wrap) and not(parent::sec)">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:if>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * External hyperlinks                                    * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="ext-link" mode="typesetting">
        <xsl:choose>
            <xsl:when test="$medium = 'electronic'">
                <xsl:element name="fo:basic-link" use-attribute-sets="hyperlink">
                    <xsl:attribute name="external-destination">
                        <xsl:text>url(</xsl:text>
                        <xsl:value-of select="node()"/>
                        <xsl:text>)</xsl:text>
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

    <!-- Superscript -->
    <xsl:template match="sup" mode="typesetting">
        <xsl:element name="fo:inline" use-attribute-sets="footnote_reference_number">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Subscript -->
    <xsl:template match="sub" mode="typesetting">
        <xsl:element name="fo:inline" use-attribute-sets="subscript">
            <xsl:apply-templates mode="typesetting"/>
        </xsl:element>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Break                                                  * -->
    <!-- ********************************************************** -->
    
    <xsl:template match="break" mode="typesetting">
        <fo:block/>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * Table of Contents (ToC) generation                     * -->
    <!-- ********************************************************** -->
    
    <xsl:template name="ToC">
        <fo:page-sequence master-reference="ToC_Sequence">
            <xsl:attribute name="force-page-count">end-on-even</xsl:attribute>

            <!-- Retrieve Heading -->
            <xsl:variable name="ToC-Heading">
                <xsl:choose>
                    <xsl:when test="/book[@xml:lang = 'de']">
                        <xsl:value-of select="$heading-ToC-de"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$heading-ToC-en"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- Running headers -->
            <fo:static-content flow-name="ToC_title_verso">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_verso">
                    <fo:page-number/>
                    <xsl:text> – </xsl:text>
                    <xsl:value-of select="$ToC-Heading"/>
                </xsl:element>
            </fo:static-content>
            <fo:static-content flow-name="ToC_title_recto">
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_petit_text do_not_hyphenate keeps-paragraph running_title_recto">
                    <xsl:value-of select="$ToC-Heading"/>
                    <xsl:text> – </xsl:text>
                    <fo:page-number/>
                </xsl:element>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body">
                <!-- Heading -->
                <xsl:element name="fo:block"
                    use-attribute-sets="fonts_chapter_title keeps-headings margin_under_title">
                    <xsl:attribute name="id">toc</xsl:attribute>
                    <xsl:value-of select="$ToC-Heading"/>
                </xsl:element>

                <!-- ToC for an edited book -->
                <xsl:if test="/book/@book-type='proceedings'">
                    
                    <xsl:for-each select="/book/book-body/book-part">

                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="space-before" select="$LineGridNormal"/>
                            <xsl:for-each
                                select="book-part-meta/contrib-group/contrib[@contrib-type = 'author']">
                                <xsl:if test="position() != 1">
                                    <xsl:value-of select="$author-name-divider_chapter-head"/>
                                </xsl:if>
                                <xsl:value-of select="name/given-names"/>
                                <xsl:text>&#x00A0;</xsl:text>
                                <!-- Non breaking space to keep author names together -->
                                <xsl:value-of select="name/surname"/>
                            </xsl:for-each>
                        </xsl:element>

                        <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                            <xsl:attribute name="text-align-last">justify</xsl:attribute>
                            <xsl:if test="$medium = 'electronic'">
                                <xsl:element name="fo:basic-link" use-attribute-sets="hyperlink">
                                    <xsl:attribute name="internal-destination">
                                        <xsl:value-of select="generate-id(.)"/>
                                    </xsl:attribute>
                                    <xsl:apply-templates select="book-part-meta/title-group/title"/>
                                    <fo:leader leader-pattern="space"/>
                                    <fo:page-number-citation ref-id="{generate-id(.)}"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$medium = 'print'">
                                <xsl:apply-templates select="book-part-meta/title-group/title"/>
                                <fo:leader leader-pattern="space"/>
                                <fo:page-number-citation ref-id="{generate-id(.)}"/>
                            </xsl:if>
                        </xsl:element>
                        <xsl:if test="book-part-meta/title-group/subtitle">
                            <xsl:element name="fo:block" use-attribute-sets="fonts_regular_text">
                                <xsl:apply-templates select="book-part-meta/title-group/subtitle"/>
                            </xsl:element>
                        </xsl:if>

                    </xsl:for-each>

                </xsl:if>
                
                <!-- ToC for a monograph -->
                <xsl:if test="/book/@book-type='monograph'">
                    
                    <xsl:element name="fo:list-block">
                        <!-- Generate toc entries for the book body -->
                        <xsl:call-template name="toc-book-body"/>
                        <!-- Generate toc entries for the book backmatter -->
                        <xsl:call-template name="toc-book-backmatter"/>
                    </xsl:element>
                    
                </xsl:if>
                
            </fo:flow>

        </fo:page-sequence>
    </xsl:template>

    <xsl:template name="toc-book-body">
        <xsl:apply-templates select="book/book-body" mode="toc"/>
    </xsl:template>
    
    <xsl:template name="toc-book-backmatter"/>
    
    <xsl:template match="book-body" mode="toc">
        <xsl:apply-templates select="book-part" mode="toc"/>
    </xsl:template>
    
    <xsl:template match="book-part" mode="toc">
        <!-- Create book part entry -->
        <xsl:apply-templates select="book-part-meta" mode="toc"/>
        <!-- look for more entries -->
        <xsl:apply-templates select="body" mode="toc"/>
    </xsl:template>
    
    <xsl:template match="book-part-meta" mode="toc">
        <xsl:element name="fo:list-item">
            <xsl:attribute name="margin-top">12pt</xsl:attribute>
            <xsl:element name="fo:list-item-label">
                <xsl:attribute name="end-indent"><!-- label-end() -->3em</xsl:attribute>
                <xsl:if test="title-group/label">
                    <xsl:choose>
                        <xsl:when test="ancestor::book-part[1]/@book-part-type='part'">
                            <xsl:element name="fo:block" use-attribute-sets="toc-format-part keeps-headings">
                                <xsl:apply-templates select="title-group/label" mode="toc"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="fo:block" use-attribute-sets="toc-format-first-level keeps-headings">
                                <xsl:apply-templates select="title-group/label" mode="toc"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:element>
            <xsl:element name="fo:list-item-body">
                <xsl:attribute name="start-indent"><!-- body-start() -->4em</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="ancestor::book-part[1]/@book-part-type='part'">
                        <xsl:element name="fo:block" use-attribute-sets="toc-format-part keeps-headings">
                            <xsl:attribute name="text-align-last">justify</xsl:attribute>
                            <xsl:apply-templates select="title-group/title" mode="toc"/>
                            <xsl:if test="title-group/subtitle">
                                <xsl:text>. </xsl:text>
                                <xsl:apply-templates select="title-group/subtitle" mode="toc"/>
                            </xsl:if>
                            <xsl:text> </xsl:text>
                            <xsl:element name="fo:leader" use-attribute-sets="ToC-leader"/>
                            <xsl:text> </xsl:text>
                            <xsl:element name="fo:page-number-citation">
                                <xsl:attribute name="ref-id">
                                    <xsl:value-of select="ancestor::book-part[1]/@id"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="fo:block" use-attribute-sets="toc-format-first-level keeps-headings">
                            <xsl:attribute name="text-align-last">justify</xsl:attribute>
                            <xsl:apply-templates select="title-group/title" mode="toc"/>
                            <xsl:if test="title-group/subtitle">
                                <xsl:text>. </xsl:text>
                                <xsl:apply-templates select="title-group/subtitle" mode="toc"/>
                            </xsl:if>
                            <xsl:element name="fo:inline">
                                <xsl:attribute name="font-size">10.5pt</xsl:attribute>
                            <xsl:text> </xsl:text>
                            <xsl:element name="fo:leader" use-attribute-sets="ToC-leader"/>
                            <xsl:text> </xsl:text>
                            <xsl:element name="fo:page-number-citation">
                                <xsl:attribute name="ref-id">
                                    <xsl:value-of select="ancestor::book-part[1]/@id"/>
                                </xsl:attribute>
                            </xsl:element>
                            </xsl:element>
                        </xsl:element>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="body" mode="toc">
        <xsl:if test="(count(ancestor::book-part) + count(ancestor-or-self::sec)) &lt; $ToC-levels">
            <xsl:apply-templates select="book-part | sec" mode="toc"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="sec" mode="toc">
        <xsl:if test="not(@sec-type='hide_in_toc')">
            <xsl:element name="fo:list-item">
                 <xsl:element name="fo:list-item-label">
                    <xsl:attribute name="end-indent"><!-- label-end() -->3em</xsl:attribute>
                    <xsl:if test="label">
                        <xsl:element name="fo:block" use-attribute-sets="toc-format-levels-after-first keeps-headings">
                            <xsl:apply-templates select="label" mode="toc"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="fo:list-item-body">
                    <xsl:attribute name="start-indent"><!-- body-start() -->4em</xsl:attribute>
                    <xsl:element name="fo:block" use-attribute-sets="toc-format-levels-after-first keeps-headings">
                        <xsl:attribute name="text-align-last">justify</xsl:attribute>
                        <xsl:apply-templates select="title" mode="toc"/>
                        <xsl:if test="subtitle">
                            <xsl:text>. </xsl:text>
                            <xsl:apply-templates select="subtitle" mode="toc"/>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <xsl:element name="fo:leader" use-attribute-sets="ToC-leader"/>
                        <xsl:text> </xsl:text>
                        <fo:page-number-citation ref-id="{@id}"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="(count(ancestor::book-part) + count(ancestor-or-self::sec)) &lt; $ToC-levels">
            <xsl:apply-templates select="sec" mode="toc"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="label | title | subtitle" mode="toc">
        <xsl:apply-templates mode="typesetting"/>
    </xsl:template>

    <!-- ********************************************************** -->
    <!-- * PDF bookmark tree                                      * -->
    <!-- ********************************************************** -->
    
    <xsl:template name="pdf-bookmark-tree">
        <xsl:if test="($medium='electronic' and (($pdf_bookmark='electronic') or ($pdf_bookmark='both'))) or ($medium='print' and (($pdf_bookmark='print') or ($pdf_bookmark='both')))">
            <fo:bookmark-tree>
                
                <!-- Cover -->
                <xsl:if test="$medium='electronic' and $include-cover-images='true' and $pdf_bookmark_cover_entries='yes'">
                    <fo:bookmark internal-destination="cover_1">
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="/book/@xml:lang = 'de'">
                                    <xsl:value-of select="$front_cover_de"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$front_cover_en"/>
                                </xsl:otherwise>
                            </xsl:choose>    
                        </fo:bookmark-title>
                    </fo:bookmark>
                </xsl:if>
                
                <!-- Frontmatter -->
                <xsl:if test="$pdf_bookmark_fm_entries='yes'">
                    <fo:bookmark internal-destination="half-title" starting-state="hide">
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="/book/@xml:lang = 'de'">
                                    <xsl:value-of select="$frontmatter_de"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$frontmatter_en"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:bookmark-title>
                            <!-- Half title -->
                            <fo:bookmark internal-destination="half-title">
                                <fo:bookmark-title>
                                    <xsl:choose>
                                        <xsl:when test="/book/@xml:lang = 'de'">
                                            <xsl:value-of select="$half_title_de"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$half_title_en"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:bookmark-title>
                            </fo:bookmark>
                            <!-- Series title -->
                            <xsl:if test="/book/collection-meta">
                                <fo:bookmark internal-destination="series-title">
                                    <fo:bookmark-title>
                                        <xsl:choose>
                                            <xsl:when test="/book/@xml:lang = 'de'">
                                                <xsl:value-of select="$series_title_de"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$series_title_en"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:bookmark-title>
                                </fo:bookmark>
                            </xsl:if>
                            <!-- Main title -->
                            <fo:bookmark internal-destination="main-title">
                                <fo:bookmark-title>
                                    <xsl:choose>
                                        <xsl:when test="/book/@xml:lang = 'de'">
                                            <xsl:value-of select="$main_title_de"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$main_title_en"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:bookmark-title>
                            </fo:bookmark>
                            <!-- Impressum -->
                            <fo:bookmark internal-destination="impressum">
                                <fo:bookmark-title>
                                    <xsl:choose>
                                        <xsl:when test="/book/@xml:lang = 'de'">
                                            <xsl:value-of select="$impressum_de"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$impressum_en"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:bookmark-title>
                            </fo:bookmark>
                    </fo:bookmark>
                    <!-- Acknowledgements -->
                        <!-- not yet implemented -->
                    <!-- Table of Contents -->
                    <fo:bookmark internal-destination="toc">
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="/book/@xml:lang = 'de'">
                                    <xsl:value-of select="$heading-ToC-de"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$heading-ToC-en"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:bookmark-title>
                    </fo:bookmark>
                </xsl:if>
                
                <!-- Main book -->
                <xsl:apply-templates select="/book/book-body/book-part" mode="pdf-bookmark-tree"/>
                
                <!-- Backmatter -->
                <xsl:if test="$FootnoteHandling = 'endnote_book_backmatter'">
                    <xsl:element name="fo:bookmark">
                        <xsl:attribute name="internal-destination">
                            <xsl:text>book_endnotes</xsl:text>
                        </xsl:attribute>
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="/book/@xml:lang = 'de'">
                                    <xsl:value-of select="$heading_endnotes_chapter_backmatter_de"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$heading_endnotes_chapter_backmatter_en"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:bookmark-title>
                    </xsl:element>
                </xsl:if>
                
                <!-- Back Cover -->
                <xsl:if test="$medium='electronic' and $include-cover-images='true' and $pdf_bookmark_cover_entries='yes'">
                    <fo:bookmark internal-destination="cover_4">
                        <fo:bookmark-title>
                            <xsl:choose>
                                <xsl:when test="/book/@xml:lang = 'de'">
                                    <xsl:value-of select="$back_cover_de"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$back_cover_en"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:bookmark-title>
                    </fo:bookmark>
                </xsl:if>
                
            </fo:bookmark-tree>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="book-part" mode="pdf-bookmark-tree">
        <xsl:element name="fo:bookmark">
            <xsl:attribute name="internal-destination">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:attribute name="starting-state">hide</xsl:attribute>
            <fo:bookmark-title>
                <xsl:if test="book-part-meta/title-group/label">
                    <xsl:value-of select="book-part-meta/title-group/label"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:if test="/book/@book-type='proceedings'">
                    <xsl:for-each select="book-part-meta/contrib-group/contrib[@contrib-type = 'author']">
                        <xsl:if test="position() = 1">                            
                            <xsl:value-of select="name/given-names"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="name/surname"/>
                            <xsl:if test="position() = last()">
                                <xsl:text>: </xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="position() = 2">
                            <xsl:text> et al.: </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:value-of select="book-part-meta/title-group/title"/>
                <xsl:if test="book-part-meta/title-group/subtitle">
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="book-part-meta/title-group/subtitle"/>
                </xsl:if>
            </fo:bookmark-title>
            <xsl:apply-templates select="body/book-part | body/sec | back" mode="pdf-bookmark-tree"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="sec" mode="pdf-bookmark-tree">
        <xsl:choose>
            <xsl:when test="child::title">
                <xsl:element name="fo:bookmark">
                    <xsl:attribute name="internal-destination">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:attribute name="starting-state">hide</xsl:attribute>
                    <fo:bookmark-title>
                        <xsl:if test="label">
                            <xsl:value-of select="label"/>
                            <xsl:text>. </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="title"/>
                        <xsl:if test="subtitle">
                            <xsl:text>. </xsl:text>
                            <xsl:value-of select="subtitle"/>
                        </xsl:if>                
                    </fo:bookmark-title>
                    <xsl:apply-templates select="sec" mode="pdf-bookmark-tree"/>
                </xsl:element>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="sec" mode="pdf-bookmark-tree"/>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="back" mode="pdf-bookmark-tree">
        <!-- Endnotes (if applicable) -->
        <xsl:if test="$FootnoteHandling='endnote_chapter_backmatter'">
            <xsl:element name="fo:bookmark">
               <xsl:attribute name="internal-destination">
                   <xsl:value-of select="ancestor::book-part[1]/@id"/>
                   <xsl:text>_chap_endnotes</xsl:text>
               </xsl:attribute>
                <fo:bookmark-title>
                    <xsl:choose>
                        <xsl:when test="/book/@xml:lang = 'de'">
                            <xsl:value-of select="$heading_endnotes_chapter_backmatter_de"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$heading_endnotes_chapter_backmatter_en"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:bookmark-title>
            </xsl:element>
        </xsl:if>
        <!-- Bibliography -->
        <xsl:apply-templates select="ref-list" mode="pdf-bookmark-tree"/>
    </xsl:template>
    
    <xsl:template match="ref-list" mode="pdf-bookmark-tree">
        <xsl:element name="fo:bookmark">
            <xsl:attribute name="internal-destination">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:attribute name="starting-state">hide</xsl:attribute>
            <fo:bookmark-title>
                <xsl:if test="label">
                    <xsl:value-of select="label"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:value-of select="title"/>
            </fo:bookmark-title>
            <xsl:apply-templates select="ref-list" mode="pdf-bookmark-tree"/>
        </xsl:element>        
    </xsl:template>

</xsl:stylesheet>
