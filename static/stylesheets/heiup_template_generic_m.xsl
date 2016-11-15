<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <!-- ***************************************************************************** -->
    <!--    Main Language                                                              -->
    <!-- ***************************************************************************** -->
    <xsl:variable name="MainLanguage">de</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--    Include static text                                                        -->
    <!-- ***************************************************************************** -->
    <xsl:include href="heiup_static_strings.xsl"/>

    <!-- ***************************************************************************** -->
    <!--    Color management and PDF specification                                     -->
    <!-- ***************************************************************************** -->
    <xsl:variable name="ColorProfile_CMYK">/home/fk/color_profiles/cmyk/CoatedFOGRA39.icc</xsl:variable>
    <xsl:variable name="ColorProfile_RGB">/home/fk/color_profiles/rgb/AdobeRGB1998.icc</xsl:variable>
    <xsl:variable name="Electronic_PDF_Standard">PDF/A-1a:2005</xsl:variable>
    <xsl:variable name="Print_PDF_Standard">PDF/X-1a:2003</xsl:variable>
    
    <!-- ***************************************************************************** -->
    <!--    Page and margins                                                           -->
    <!-- ***************************************************************************** -->

    <!-- Page format -->
    <xsl:variable name="PageWidth">155mm</xsl:variable>
    <xsl:variable name="PageHeight">235mm</xsl:variable>
    
    <!-- Page margins -->    
    <xsl:variable name="MarginTop">17mm</xsl:variable>
    <xsl:variable name="MarginBottom">25mm</xsl:variable>
    <xsl:variable name="MarginInner">20mm</xsl:variable>
    <xsl:variable name="MarginOuter">20mm</xsl:variable>
    <xsl:variable name="RunningHeadHeight">8mm</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--    Chapter page handling                                                      -->
    <!-- ***************************************************************************** -->

    <!-- Defines if chapters generally start on a left (recto) page or not 
         Allowed values:
         auto          Force the last page in this page-sequence to be an odd-page if 
                       the initial-page-number of the next page-sequence is even. Force 
                       it to be an even-page if the initial-page-number of the next 
                       page-sequence is odd. If there is no next page-sequence or if the 
                       value of its initial-page-number is "auto" do not force any page.
         even          Force an even number of pages in this page-sequence.
         odd           Force an odd number of pages in this page-sequence.
         end-on-even   Force the last page in this page-sequence to be an even-page.
         end-on-odd    Force the last page in this page-sequence to be an odd-page.
         no-force      Do not force either an even or an odd number of pages in this 
                       page-sequence                                                   -->
    <xsl:variable name="ChapterPageHandling">end-on-even</xsl:variable>

    <!-- Define if footnotes will be footnotes or endnotes:
        "footnote" - Footnotes
        "endnote"  - Endnotes -->
    <xsl:variable name="FootnoteHandling">footnote</xsl:variable>
    
    <!-- ***************************************************************************** -->
    <!--   General fonts, font size and line height definition                         -->
    <!-- ***************************************************************************** -->

    <!-- Classes (in pt.):
            Normal Text
                XS 9.5/11.5; S 10/12; M 10.5/13; L 11/13.5; XL 12/14.5
            Petit Text
                XS 8/10; S 8.5/11; M 9/12; L 9.5/12.5; XL 10/12 -->

    <!-- Line Grid -->
    <xsl:variable name="LineGridNormal">13pt</xsl:variable>
    <xsl:variable name="LineGridPetit">12pt</xsl:variable>
    
    <!-- Fonts -->
    <xsl:variable name="AlternateFont">Helvetica</xsl:variable>
    <xsl:variable name="general_font_family_alternate">Helvetica</xsl:variable>
    <xsl:variable name="general_font_family_base">Times</xsl:variable>
    
    <!-- Font Sizes -->
    <xsl:variable name="BaseFontSize">10.5pt</xsl:variable>
    <xsl:variable name="PetitFontSize">9pt</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--   Footnote separator                                                          -->
    <!-- ***************************************************************************** -->

    <!-- Use a footnote separator or not -->
    <!-- Parameter will be ignored if footnotes are typeset as endnotes -->
    <xsl:variable name="footnote-separator">yes</xsl:variable>

    <!-- Will be ignored if the variable above is set to "no" -->
    <xsl:attribute-set name="footnote_sep">
        <xsl:attribute name="leader-length">25mm</xsl:attribute>
        <xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
        <xsl:attribute name="leader-pattern">rule</xsl:attribute>
        <xsl:attribute name="rule-style">solid</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>

    <!-- ***************************************************************************** -->
    <!-- Attribute sets for FO Formatter                                               -->
    <!-- Contact: Frank Krabbes, krabbes@ub.uni-heidelberg.de                          -->
    <!-- ***************************************************************************** -->
    
    <!-- ***************************************************************************** -->
    <!-- Font properties                                                               -->
    <!-- ***************************************************************************** -->
    
    <!-- Regular text properties -->
    <xsl:attribute-set name="fonts_regular_text">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_base"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$BaseFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$LineGridNormal"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Petit text properties -->
    <xsl:attribute-set name="fonts_petit_text">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_base"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$PetitFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!-- Paragraph                                                                     -->
    <!-- ***************************************************************************** -->
    
    <!-- Standard Paragraph -->
    <xsl:attribute-set name="paragraph_formats">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!-- Hyphenation                                                                   -->
    <!-- ***************************************************************************** -->
    
    <!-- Hypenate -->
    <xsl:attribute-set name="hyphenate">
        <xsl:attribute name="hyphenate">true </xsl:attribute>
        <!-- <xsl:attribute name="hyphenation-character">&#x2010;</xsl:attribute> --><!-- use the default character -->
        <xsl:attribute name="hyphenation-keep">auto</xsl:attribute>
        <xsl:attribute name="hyphenation-ladder-count">3</xsl:attribute>
        <xsl:attribute name="hyphenation-push-character-count">2</xsl:attribute>
        <xsl:attribute name="hyphenation-remain-character-count">2</xsl:attribute>       
        <xsl:attribute name="language">
            <xsl:value-of select="$MainLanguage"/>
        </xsl:attribute>       
    </xsl:attribute-set>
    
    <!-- Do not hyphenate -->
    <xsl:attribute-set name="do_not_hyphenate">
        <xsl:attribute name="hyphenate">false </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!-- Keeps                                                                         -->
    <!-- ***************************************************************************** -->
    
    <!-- Keep rules for standard paragraphs -->
    <xsl:attribute-set name="keeps-paragraph">
        <xsl:attribute name="orphans">1</xsl:attribute>
        <xsl:attribute name="widows">2</xsl:attribute>
        <xsl:attribute name="keep-with-next">auto</xsl:attribute>
        <xsl:attribute name="keep-with-previous">auto</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!-- Character formats                                                             -->
    <!-- ***************************************************************************** -->
    
    <!-- Footnote reference number -->
    <xsl:attribute-set name="footnote_reference_number">
        <xsl:attribute name="font-size">70%</xsl:attribute>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Emphasis for cross references and hyperlinks; only for $medium='electronic' -->
    <!-- ATTENTION: Only use formats with identical text flow!!! -->
    <xsl:attribute-set name="hyperlink">
        <xsl:attribute name="color">blue</xsl:attribute>
        <!--    none   No decoration
                underline	Each line of text is underlined.
                no-underline	Turns off underlining, if any.
                overline	Each line of text has a line above it.
                no-overline	Turns off overlining, if any.
                line-through	Each line of text has a line through the middle.
                no-line-through	Turns off line-through, if any.
                blink	Text blinks (alternates between visible and invisible). Conforming user agents are not required to support this value.
                no-blink	Turns off blinking, if any. -->
        <xsl:attribute name="text-decoration">none</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>