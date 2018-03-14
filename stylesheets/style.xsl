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
         * Style definitions and configuration file                       *
         ******************************************************************
           First release to be published under 
           Creative Commons License CC BY-NC-ND 4.0
           (https://creativecommons.org/licenses/by-nc-nd/4.0/)
     
           See documentation for further information.
           
           Frank Krabbes
           University Library Heidelberg, Publication Services
           Plöck 107-109, 69117 Heidelberg, Germany
           Mail to: krabbes@ub.uni-heidelberg.de

           Structure of this configuration file:
           
           Section I   : Generic Configuration
           Section II  : Language settings and localizations
           Section III : Definitions of layout and typography

    -->

    <!-- ******************************************************************
         * Section I: Generic Configuration                               *
         ****************************************************************** -->
        
    <!-- Front matter -->
    
    <!-- Pagination of the front matter of a monograph
            Values:
                1 : arabic page numbers (1, 2, ...)
                i : lowercase roman numbers (i, ii, ...)
                I : uppercase roman numbers (I, II, ...) -->
    <xsl:variable name="_front-matterMonographPagination">1</xsl:variable>
        
    <!-- Pagination of the front matter in a proceedings
            Values:
                1 : arabic page numbers (1, 2, ...)
                i : lowercase roman numbers (i, ii, ...)
                I : uppercase roman numbers (I, II, ...) -->
    <xsl:variable name="_front-matterProceedingsPagination">1</xsl:variable>
    
    <!-- List of Figures
            Create a List of Figures
            Values:
                yes : List of Figures will be generated 
                no  : No List of Figures will be generated 
            Nota bene: Insertion point can be defined by using the processing instruction <?List_of_Figures ?> -->
    <xsl:variable name="_front-matterListofIllustrations">no</xsl:variable>    

    <!-- List of Tables
            Create a List of Tables
            Values:
                yes : List of Tables will be generated 
                no  : No List of Tables will be generated
            Nota bene: Insertion point can be defined by using the processing instruction <?List_of_Tables ?> -->
    <xsl:variable name="_front-matterListofTables">no</xsl:variable>    
    
    <!-- Handling of foot- and endnotes
            Values:
                footnotes           : render as footnotes
                book-back-matter    : render as endnotes in the book back matter
                chapter-back-matter : render as endnotes in the chapter back matter -->
    <xsl:variable name="_footnote_handling">footnotes</xsl:variable>
    
    <!-- Running headers
            Values:
                yes : Running headers will be generated on top of the page
                no  : No running headers will be generated -->
    <xsl:variable name="running_headers">yes</xsl:variable>
    
    <!-- Position of the page number
            Values:
                header : Page number is positioned in the header of the page
                footer : Page number is positioned in the footer of the page
            Nota bene: The page number of the first page of a section is not affected by this option. -->    
    <xsl:variable name="page_number">header</xsl:variable>
    
    <!-- Non interactive (print) PDF features -->
    
    <!-- Non interactive (print) PDF version (AntennaHouse formatter only)
            Values:
                PDF1.3
                PDF1.4
                PDF1.5
                PDF1.6
                PDF1.7
                PDF/X-1a:2001 no-LT
                PDF/X-3:2002 no-LT
                PDF/X-1a:2003 no-LT
                PDF/X-2:2003 no-LT
                PDF/X-3:2003 no-LT
                PDF/X-4:2010 no-LT
                PDF/A-1a:2005 no-LT
                PDF/A-1b:2005 no-LT
                PDF/A-2a:2011 V6.5 no-LT
                PDF/A-2b:2011 V6.5 no-LT
                PDF/A-2u:2011 V6.5 no-LT
                PDF/A-3a:2012 V6.5 no-LT
                PDF/A-3b:2012 V6.5 no-LT
                PDF/A-3u:2012 V6.5 no-LT
                PDF1.5/UA-1:2014 no-LT
                PDF1.6/UA-1:2014 no-LT
                PDF1.7/UA-1:2014
            Nota bene: These versions are supported by AntennaHouse Formatter 6.5.
                For other version please consult the documentation. -->
    <xsl:variable name="_non-interactive-pdf-version">PDF1.5</xsl:variable>
    
    <!-- Non interactive (print) PDF color profile 
            Values:
                Path to icc file or
                blank if no color profile is to be embedded -->
    <!-- <xsl:variable name="_non-interactive-pdf-color-profile">/Volumes/DATENSTICK/14 XSL-FO/Quellen/resources/color_profiles/CoatedFOGRA39.icc</xsl:variable> -->
    <xsl:variable name="_non-interactive-pdf-color-profile">/home/fk/xsl-fo/resources/color-profiles/CoatedFOGRA39.icc</xsl:variable>
    
    <!-- Interactive PDF features -->

    <!-- Interactive PDF version (AntennaHouse formatter only)
            Values:
                PDF1.3
                PDF1.4
                PDF1.5
                PDF1.6
                PDF1.7
                PDF/X-1a:2001 no-LT
                PDF/X-3:2002 no-LT
                PDF/X-1a:2003 no-LT
                PDF/X-2:2003 no-LT
                PDF/X-3:2003 no-LT
                PDF/X-4:2010 no-LT
                PDF/A-1a:2005 no-LT
                PDF/A-1b:2005 no-LT
                PDF/A-2a:2011 V6.5 no-LT
                PDF/A-2b:2011 V6.5 no-LT
                PDF/A-2u:2011 V6.5 no-LT
                PDF/A-3a:2012 V6.5 no-LT
                PDF/A-3b:2012 V6.5 no-LT
                PDF/A-3u:2012 V6.5 no-LT
                PDF1.5/UA-1:2014 no-LT
                PDF1.6/UA-1:2014 no-LT
                PDF1.7/UA-1:2014
            Nota bene: These versions are supported by AntennaHouse Formatter 6.5.
                For other version please consult the documentation. -->
    <xsl:variable name="_interactive-pdf-version">PDF1.5</xsl:variable>
    
    <!-- Interactive PDF color profile
            Values:
                Path to icc file or
                blank if no color profile is to be embedded -->
    <!-- <xsl:variable name="_interactive-pdf-color-profile">/Volumes/DATENSTICK/14 XSL-FO/Quellen/resources/color_profiles/AdobeRGB1998.icc</xsl:variable>-->
    <xsl:variable name="_interactive-pdf-color-profile">/home/fk/xsl-fo/resources/color-profiles/AdobeRGB1998.icc</xsl:variable>
    
    <!-- PDF bookmarks
            Values:
                yes : PDF bookmarks will be generated
                no  : PDF bookmarks will not be generated -->
    <xsl:variable name="_pdf_bookmarks">yes</xsl:variable>
    
    <!-- Enable footnote hyperlinking (interactive version only)
            Values:
                yes : Internal references between footnote and reference will be generated
                no  : No internal references between footnote and reference will be generated
            Nota bene: Hyperlink formatting can be changed in the "hyperlink" attribute set. -->
    <xsl:variable name="_footnote_crossref">yes</xsl:variable>
        
    <!-- Enable section and object cross referencing (interactive version only)
            Values:
                yes : Internal references will be generated
                no  : No internal references will be generated
            Nota bene: Hyperlink formatting can be changed in the "hyperlink" attribute set. -->
    <xsl:variable name="_crossref">yes</xsl:variable>

    <!-- Enable or disable external hyperlinking (interactive version only)
            Values:
                yes : External hyperlinks will be linked and formattet
                no  : External hyperlinks will not be linked and formattet
        Nota bene: (1) Hyperlink formatting can be changed in the "hyperlink" attribute set.
                   (2) Hyperlinks may automaticly be recognized and linked by the PDF viewer. -->
    <xsl:variable name="_external_hyperlinks">yes</xsl:variable>
    
    <!-- ******************************************************************
         * Section II: Language settings and localizations                *
         ****************************************************************** -->
    
    <!-- Default language
             Used if no valid xml:lang attribute or no ISO 639 language code is found in the <book> element.
             Localized text must fully cover the default language.
             See also:
                https://jats.nlm.nih.gov/extensions/bits/tag-library/2.0/element/book.html
                https://www.iso.org/iso-639-language-codes.html -->
    <xsl:variable name="_defaultLanguage">en</xsl:variable>

    <!-- Localizations 
        either <xsl:variable name="_localization" select="document('localization.xml')/localization"/> or: -->
    <xsl:variable name="_localization">
        <localization-group name="and">
            <localization-item xml:lang="en">and</localization-item>
            <localization-item xml:lang="de">und</localization-item>
        </localization-group>
        <localization-group name="dedication">
            <localization-item xml:lang="en">Dedication</localization-item>
            <localization-item xml:lang="de">Widmung</localization-item>
        </localization-group>
        <localization-group name="endnotes">
            <localization-item xml:lang="en">Endnotes</localization-item>
            <localization-item xml:lang="de">Anmerkungen</localization-item>
        </localization-group>
        <localization-group name="epigraph">
            <localization-item xml:lang="en">Epigraph</localization-item>
            <localization-item xml:lang="de">Epigraph</localization-item>
        </localization-group>
        <localization-group name="et_al">
            <localization-item xml:lang="en">et al.</localization-item>
            <localization-item xml:lang="de">et al.</localization-item>
        </localization-group>
        <localization-group name="preliminaries">
            <localization-item xml:lang="en">Preliminaries</localization-item>
            <localization-item xml:lang="de">Vorspann</localization-item>
        </localization-group>
        <localization-group name="table-of-contents">
            <localization-item xml:lang="en">Table of Contents</localization-item>
            <localization-item xml:lang="de">Inhaltsverzeichnis</localization-item>
        </localization-group>
        <localization-group name="series_edited_by_phrase">
            <localization-item xml:lang="en">Series Editors:</localization-item>
            <localization-item xml:lang="de">Reihenherausgeber:</localization-item>
        </localization-group>
    </xsl:variable>
    
    <!-- Search and replace patterns 
        either <xsl:variable name="_patterns" select="document('patterns.xml')/patterns"/> or: -->
    <xsl:variable name="_patterns">
        
        <pattern ancestor="ext-link" xml:lang="">
            <search>(.)</search>
            <replace>$1&#8203;</replace>
            <description>Trennfuge nach beliebigem Zeichen in Hyperlinks</description>
        </pattern>
        
    </xsl:variable>
    
    <!-- ******************************************************************
         * Section III: Definitions of layout and typography              *
         ****************************************************************** -->
    
    <!-- Section III.1: Page setup -->
    
    <!-- Page dimensions, margins and type area / Seitenformat, Seitenränder und Satzspiegelbreite und -höhe
            Remark: Before making changes see the XSL-FO page model and the documentation. -->
    
    <!-- Page dimensions / Seitenformat
            Units: cm, mm, in, pt, pc, px, em
            See also: Section 5.9.13 of Extensible Stylesheet Language (XSL) Version 1.1 (W3C Recommendation) 
                      (https://www.w3.org/TR/xsl/#d0e5752) -->
    <xsl:variable name="_pageWidth">155mm</xsl:variable>
    <xsl:variable name="_pageHeight">235mm</xsl:variable>
    
    <!-- Page margins / Seitenränder
            Units: cm, mm, in, pt, pc, px, em
            See also: Section 5.9.13 of Extensible Stylesheet Language (XSL) Version 1.1 (W3C Recommendation) 
                      (https://www.w3.org/TR/xsl/#d0e5752) -->
    <xsl:variable name="_marginTop">15mm</xsl:variable>
    <xsl:variable name="_marginFoot">13mm</xsl:variable>
    <xsl:variable name="_marginInside">20mm</xsl:variable>
    <xsl:variable name="_marginOutside">20mm</xsl:variable>
    
    <!-- Inside margins -->
    <xsl:variable name="_typeAreaMarginTop">10mm</xsl:variable>
    <xsl:variable name="_typeAreaMarginFoot">8mm</xsl:variable>
    <xsl:variable name="_typeAreaMarginInside">0mm</xsl:variable>
    <xsl:variable name="_typeAreaMarginOutside">0mm</xsl:variable>
    
    <!-- Extent -->
    <xsl:variable name="_headerExtent">5mm</xsl:variable>
    <xsl:variable name="_footerExtent">5mm</xsl:variable>

    <!-- Columns -->
    <xsl:variable name="_columnsLexicon">2</xsl:variable>
    <xsl:variable name="_columnsRegister">2</xsl:variable>
    <xsl:variable name="_columnGap">
        <xsl:value-of select="$_regularLineHeight"/>
    </xsl:variable>

    <!-- Section III.2: Typography -->

    <!-- General definitions -->

    <!-- Typography Classes (recommendations; in pt.):
            Normal Text:    XS 9/11.5; S 9.5/12;   M 10/13; L 10.5/13  ; XL 12  /14.5
            Petit Text:     XS 8/10  ; S 8.5/10.5; M  9/11; L  9.5/11.5; XL 10.5/13.5 -->
        
    <!-- Fonts -->
    <xsl:attribute-set name="font_family_regular">
        <xsl:attribute name="font-family">Linux Libertine O</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="font_family_accent">
        <xsl:attribute name="font-family">Source Sans Pro</xsl:attribute>
    </xsl:attribute-set>
        
    <!-- Font sizes -->
    <xsl:variable name="_regularFontSize">10pt</xsl:variable>
    <xsl:variable name="_petitFontSize">9pt</xsl:variable>

    <!-- Line grid -->
    <xsl:variable name="_regularLineHeight">13pt</xsl:variable>
    <xsl:variable name="_petitLineHeight">11.7pt</xsl:variable>

    <!-- Regular text properties -->
    <xsl:attribute-set name="font_regular">
        <xsl:attribute name="font-size">
             <xsl:value-of select="$_regularFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
    </xsl:attribute-set>

    <!-- Petit text properties -->
    <xsl:attribute-set name="font_petit">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$_petitFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_petitLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
    </xsl:attribute-set>

    <!-- * Paragraph formatting ********************************* -->

    <!-- Indented paragraphs -->
    <xsl:attribute-set name="paragraph_indent">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">2em</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Non-indent paragraphs -->
    <xsl:attribute-set name="paragraph_no_indent">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- First paragraph of a footnote -->
    <xsl:attribute-set name="paragraph_footnote_first">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <xsl:attribute name="padding-top">1mm</xsl:attribute>
    </xsl:attribute-set>
        
    <!-- Subsequent paragraphs of a footnote -->
    <xsl:attribute-set name="paragraph_footnote_subsequent">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- Lexicon entry -->
    
    <xsl:attribute-set name="lexicon_first_paragraph_style" use-attribute-sets="font_family_regular hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size" select="$_petitFontSize"/>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height" select="$_petitLineHeight"/>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">2.5mm</xsl:attribute>
        <xsl:attribute name="text-indent">-2.5mm</xsl:attribute>
        <!-- Keeps
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute> -->  
    </xsl:attribute-set>
    
    <xsl:attribute-set name="lexicon_paragraph_style" use-attribute-sets="font_family_regular hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size" select="$_petitFontSize"/>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height" select="$_petitLineHeight"/>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">2.5mm</xsl:attribute>
        <xsl:attribute name="text-indent">0mm</xsl:attribute>
        <!-- Keeps
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute> -->  
    </xsl:attribute-set>

    <xsl:attribute-set name="lexicon-lemma">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <!-- Figure and table styles -->
    
    <!-- Caption label formatting
            Values:
                paragraph : Label is formatted as its own paragraph (inline format ignored) 
                inline    : Label is formatted inline (paragraph format ignored) -->
    <xsl:variable name="_caption_label_formatting">inline</xsl:variable>
    
    <!-- Caption -->
    <xsl:attribute-set name="caption" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font style -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$_petitFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_petitLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">0</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Label: Inline format -->
    <xsl:attribute-set name="caption-label-inline">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Label: Paragraph format -->
    <xsl:attribute-set name="caption-label" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font style -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$_petitFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_petitLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">0</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table styles -->
    
    <!-- Table body -->
    <xsl:attribute-set name="table_body_paragraph_style" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font style -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$_petitFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_petitLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">0</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table head -->
    <xsl:attribute-set name="table_head_paragraph_style" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font style -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$_petitFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_petitLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">0</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table lining
        all attributes of the fo:table element can be used -->
    <xsl:attribute-set name="table_style">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">1pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">1pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">1pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table head lining -->
    <xsl:attribute-set name="table_style_head">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">1pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Table head row lining -->
    <xsl:attribute-set name="table_style_head_row">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.25pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table head cell lining -->
    <xsl:attribute-set name="table_style_head_cell">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.25pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table body lining -->
    <xsl:attribute-set name="table_style_body">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">1pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Table head row lining -->
    <xsl:attribute-set name="table_style_body_row">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.25pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Table head cell lining -->
    <xsl:attribute-set name="table_style_body_cell">
        <xsl:attribute name="padding-left">1mm</xsl:attribute>
        <xsl:attribute name="padding-right">1mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">0.25pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.25pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Titles and Headings -->
    
    <!-- Part headings -->
    
    <!-- Part: inline labels 
            Values:
                inline    : label is formatted as inline text 
                paragraph : label is formatted as a paragraph -->
    <xsl:variable name="_part_label_formatting">paragraph</xsl:variable>
    
    <!-- Part authors: Formatting of author names -->
    <xsl:attribute-set name="part_authors" use-attribute-sets="font_family_regular font_regular do_not_hyphenate"/>

    <!-- Part label: Paragraph style of part labels, e.g. "Part 1"
        Nota bene: Part label can either be formatted as paragraph or inline. Use the appropriate formatting
        for the specific mode. -->
    <xsl:attribute-set name="part_label" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>

    <!-- Part heading: Paragraph style of heading -->
    <xsl:attribute-set name="part_heading" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>

    <!-- Part subheading: Paragraph style of subheading -->
    <xsl:attribute-set name="part_subheading" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">13pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- Chapter title -->
    
    <!-- Chapter heading: Margins of the heading block -->
    <xsl:attribute-set name="chapter_title_margins">
        <xsl:attribute name="margin-top">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="height">130pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Chapter level book divisions: inline labels 
            Values:
                inline    : label is formatted as inline text 
                paragraph : label is formatted as a paragraph -->
    <xsl:variable name="_chapter_label_formatting">inline</xsl:variable>

    <!-- Chapter label: Paragraph style of chapter labels
        Nota bene: Chapter label can either be formatted as paragraph or inline. Use the appropriate formatting
        for the specific mode. -->
    <xsl:attribute-set name="chapter_label" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>
 
    <!-- Chapter authors: Formatting of author names -->
    <xsl:attribute-set name="chapter_authors" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- Chapter heading: Paragraph style of heading -->
    <xsl:attribute-set name="chapter_heading" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- Chapter subheading: Paragraph style of subheading -->
    <xsl:attribute-set name="chapter_subheading" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- Section headings -->
    
    <!-- Heading 1 -->
    <xsl:attribute-set name="section_heading_1" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">26pt</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading 2 -->
    <xsl:attribute-set name="section_heading_2" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">10.5pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">26pt</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading 3 -->
    <xsl:attribute-set name="section_heading_3" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">10.5pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">26pt</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Heading 4 -->
    <xsl:attribute-set name="section_heading_4" use-attribute-sets="font_family_regular do_not_hyphenate">
        <!-- Font attributes -->
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Spaces -->
        <xsl:attribute name="space-before">26pt</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$_regularLineHeight"/>
        </xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Preliminaries -->
    
    <!-- Half title -->
    <xsl:attribute-set name="half_title" use-attribute-sets="font_family_regular font_regular do_not_hyphenate">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="text-align-last">center</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Series title -->
    
    <xsl:attribute-set name="series_title" use-attribute-sets="half_title">
        <xsl:attribute name="space-after" select="$_regularLineHeight"/>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="series_subtitle" use-attribute-sets="half_title"/>

    <xsl:attribute-set name="series_edited_by_phrase" use-attribute-sets="half_title"/>
    
    <xsl:attribute-set name="series_editors" use-attribute-sets="half_title"/>
    
    <!-- Keeps and spaces -->
    
    <!-- [...] -->

    <!-- Hyphenation -->

    <!-- Hypenate -->
    <xsl:attribute-set name="hyphenate">
        <xsl:attribute name="hyphenate">true</xsl:attribute>
        <!-- <xsl:attribute name="hyphenation-character">&#x2010;</xsl:attribute> --><!-- use the default character -->
        <xsl:attribute name="hyphenation-keep">auto</xsl:attribute>
        <xsl:attribute name="hyphenation-ladder-count">4</xsl:attribute>
        <xsl:attribute name="hyphenation-push-character-count">3</xsl:attribute>
        <xsl:attribute name="hyphenation-remain-character-count">3</xsl:attribute>       
    </xsl:attribute-set>
        
    <!-- Do not hyphenate -->
    <xsl:attribute-set name="do_not_hyphenate">
        <xsl:attribute name="hyphenate">false</xsl:attribute>
    </xsl:attribute-set>

    <!-- Footnote separator line -->
    
    <!-- Footnote separator line
           Values:
                yes : footnote separator line will be rendered as configured 
                no  : no footnote separator will be rendered -->
    <xsl:variable name="_footnote_separator_line">no</xsl:variable>
        
    <!-- Will be ignored if the variable above is set to "no" -->
    <xsl:attribute-set name="footnote_separator_line_definition">
        <xsl:attribute name="leader-length">25mm</xsl:attribute>
        <xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
        <xsl:attribute name="leader-pattern">rule</xsl:attribute>
        <xsl:attribute name="rule-style">solid</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>
             
    <!-- Special formats -->
        
    <!-- Dedication -->
    <xsl:attribute-set name="paragraph_dedication">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="text-align-last">center</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Epigraph as book division -->
    <xsl:attribute-set name="paragraph_epigraph">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="text-align-last">center</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Epigraph and dedication in section -->
    <xsl:attribute-set name="paragraph_epigraph_section" use-attribute-sets="font_family_regular do_not_hyphenate font_petit">
        <xsl:attribute name="margin-left">50mm</xsl:attribute>
        <xsl:attribute name="margin-right">5mm</xsl:attribute>
        <!-- Paragraph justification -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0</xsl:attribute>
        <!-- Keeps -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
            
    <!-- Bibliography -->
    <xsl:attribute-set name="paragraph_bib_entry">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="start-indent">2em</xsl:attribute>
        <xsl:attribute name="text-indent">-2em</xsl:attribute>
    </xsl:attribute-set>

    <!-- Superscript -->
    <xsl:attribute-set name="superscript">
        <xsl:attribute name="font-size">70%</xsl:attribute>
        <xsl:attribute name="baseline-shift">2.8pt</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- Subscript -->
    <xsl:attribute-set name="subscript">
        <xsl:attribute name="font-size">70%</xsl:attribute>
        <xsl:attribute name="baseline-shift">-2pt</xsl:attribute>        
    </xsl:attribute-set>

    <!-- Running headers -->
    <xsl:attribute-set name="paragraph_header_odd_page">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="paragraph_header_even_page">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- Emphasis for cross references and hyperlinks; only for $medium='interactive'
            ATTENTION: Use formats with identical text flow only!!! -->
    <xsl:attribute-set name="hyperlink">
        <xsl:attribute name="color">blue</xsl:attribute>
        <!--    none             No decoration
                underline	     Each line of text is underlined.
                no-underline	 Turns off underlining, if any.
                overline	     Each line of text has a line above it.
                no-overline	     Turns off overlining, if any.
                line-through	 Each line of text has a line through the middle.
                no-line-through	 Turns off line-through, if any.
                blink	         Text blinks (alternates between visible and invisible). Conforming user agents are not required to support this value.
                no-blink	     Turns off blinking, if any. -->
             <xsl:attribute name="text-decoration">none</xsl:attribute>
        </xsl:attribute-set>
        
</xsl:stylesheet>