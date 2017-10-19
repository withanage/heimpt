<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

<!-- **********************************************************
     * HeiUP PDF Formatter for XSL FO 1.1                     *
     * Stylesheet                                             *
     *                                  Not for production!   *
     * Contact:      Frank Krabbes                            *
     *               krabbes@ub.uni-heidelberg.de             *
     +               Copyright 2016 CC-BY-NC-ND               *
     ********************************************************** -->

    <xsl:variable name="MainLanguage">de</xsl:variable>
    
    <!-- ***************************************************************************** -->
    <!--    Color management and PDF specification                                     -->
    <!-- ***************************************************************************** -->
    
    <!-- Define the color system used for electronic and print PDF
            values:
                RGB : RGB color system -->
    <xsl:variable name="Electronic_PDF_ColorSystem">RGB</xsl:variable>
    <xsl:variable name="Print_PDF_ColorSystem">RGB</xsl:variable>
    
    <!-- Color profiles -->
    <xsl:variable name="ICC-Profile">/Library/Application Support/Adobe/Color/Profiles/Recommended/AdobeRGB1998.icc</xsl:variable>
 
    <!-- PDF Standards for electronic PDF output
            values: 
                PDF/A-1a:2005
                PDF/A-1b:2005
         Please note that not every standard is supported by every formatter. Consult the documention
         of the formatter you use. This parameter is not used for FOP. FOP only supports configuration
         of the pdf standard using the configuration file or command line parameters. -->
    <xsl:variable name="Electronic_PDF_Standard">PDF/A-1a:2005</xsl:variable>
    
    <!--    values: 
                PDF/X-1a:2001
                PDF/X-1a:2003
                PDF/X-2:2003
                PDF/X-3:2002
                PDF/X-3:2003
                PDF/X-4:2008
         Please note that not every standard is supported by every formatter. Consult the documention
         of the formatter you use. This parameter is not used for FOP. FOP only supports configuration
         of the pdf standard using the configuration file or command line parameters. -->
    <xsl:variable name="Print_PDF_Standard">PDF/X-3:2003</xsl:variable>
    
    <!-- ***************************************************************************** -->
    <!--    Page and margins                                                           -->
    <!-- ***************************************************************************** -->

    <!-- Page format -->
    <xsl:variable name="PageWidth">155mm</xsl:variable>
    <xsl:variable name="PageHeight">220mm</xsl:variable>
    
    <!-- Page margins -->    
    <xsl:variable name="MarginTop">12.5mm</xsl:variable>
    <xsl:variable name="MarginBottom">12.5mm</xsl:variable>
    <xsl:variable name="MarginInner">20mm</xsl:variable>
    <xsl:variable name="MarginOuter">20mm</xsl:variable>
    
    <!-- Column -->
    <xsl:variable name="ColumnWidth">105mm</xsl:variable>
    <xsl:variable name="ColumnHeight">175mm</xsl:variable>    

    <!-- ***************************************************************************** -->
    <!--    Book cover handling (ePDF only)                                            -->
    <!-- ***************************************************************************** -->
    <!--    values: 
                true  : includes cover images in the pdf file
                false : no cover images are shown in the pdf file -->
    <xsl:variable name="include-cover-images">false</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--    Series title page                                                          -->
    <!-- ***************************************************************************** -->
    
    <!-- Create a series title page or leave it blank
            values:
                yes : create a series title page after the half title page
                no  : no not create a series title page -->
    <xsl:variable name="series_title_page">yes</xsl:variable>
    
    <!-- Formats -->

    <!-- Series title -->
    <xsl:attribute-set name="series_title_main_title_format">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$BaseFontSize"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$LineGridNormal"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Series subtitle -->
    <xsl:attribute-set name="series_title_subtitle_format">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
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
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-top">3mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- Series editors -->
    <!-- Leave element blank if no special text is to be included: <xsl:variable name="series_edited_by_en"/> -->
    <xsl:variable name="series_edited_by_en">Edited by</xsl:variable>
    <xsl:variable name="series_edited_by_de">Herausgegeben von</xsl:variable>
    <xsl:variable name="series_edited_name_divider">, </xsl:variable>
    <xsl:variable name="series_edited_name_divider_last_de"> und </xsl:variable>
    <xsl:variable name="series_edited_name_divider_last_en"> and </xsl:variable>
    
    <xsl:attribute-set name="series_title_editors_format">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
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
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-top">3mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Volume number -->
    <xsl:variable name="series_title_volume_number_prefix_en">Volume </xsl:variable>
    <xsl:variable name="series_title_volume_number_prefix_de">Band </xsl:variable>
    
    <xsl:attribute-set name="series_title_volume_number_format">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
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
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-top">3mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!--    PDF Bookmarks                                                              -->
    <!-- ***************************************************************************** -->

    <!-- Create PDF Bookmarks
            values:
                electronic : PDF bookmarks in electronic version only 
                print      : PDF bookmarks in print version only 
                both       : PDF bookmarks in electronic and print version 
                none       : PDF bookmarks are not included -->
    <xsl:variable name="pdf_bookmark">electronic</xsl:variable>
        
    <!-- Create cover entries in PDF bookmark list
            values:
                yes : Cover entries will be created 
                no  : No cover entries will be created -->
    <xsl:variable name="pdf_bookmark_cover_entries">yes</xsl:variable>

    <!-- Create entries for frontmatter parts in PDF bookmark list
            values:
                yes : Cover entries will be created 
                no  : No cover entries will be created -->
    <xsl:variable name="pdf_bookmark_fm_entries">yes</xsl:variable>

    <!-- Static text for PDF bookmark entries -->

    <xsl:variable name="front_cover_en">Front cover</xsl:variable><!-- default -->
    <xsl:variable name="front_cover_de">Cover</xsl:variable>

    <xsl:variable name="frontmatter_en">Frontmatter</xsl:variable><!-- default -->
    <xsl:variable name="frontmatter_de">Titelei</xsl:variable>    
    
    <xsl:variable name="half_title_en">Half title</xsl:variable><!-- default -->
    <xsl:variable name="half_title_de">Schmutztitel</xsl:variable>

    <xsl:variable name="series_title_en">Series title</xsl:variable><!-- default -->
    <xsl:variable name="series_title_de">Reihentitel</xsl:variable>

    <xsl:variable name="main_title_en">Title page</xsl:variable><!-- default -->
    <xsl:variable name="main_title_de">Titelblatt</xsl:variable>
    
    <xsl:variable name="impressum_en">Impressum</xsl:variable><!-- default -->
    <xsl:variable name="impressum_de">Impressum</xsl:variable>

    <xsl:variable name="back_cover_en">Back cover</xsl:variable><!-- default -->
    <xsl:variable name="back_cover_de">Rückencover</xsl:variable>
    
    <!-- ***************************************************************************** -->
    <!--    Table of Contents                                                          -->
    <!-- ***************************************************************************** -->
    <!-- Heading for the table of contents.
            value: 
                Unicode text string -->
    <xsl:variable name="heading-ToC-en">Contents</xsl:variable><!-- default -->
    <xsl:variable name="heading-ToC-de">Inhaltsverzeichnis</xsl:variable>
        
    <!-- Hierarchy levels to include in the Table of Contents.
            value:
                Integer > 0 -->
    <xsl:variable name="ToC-levels">2</xsl:variable>
    
    <!-- Configuration of the leader between heading and page number -->
    <xsl:attribute-set name="ToC-leader">
    
        <!-- Sequences of characters between heading and page number, most likely dots.
                values:
                    dots  : dots
                    space : spaces used -->    
        <xsl:attribute name="leader-pattern">space</xsl:attribute>

        <!-- Width of a single sequence of leader patters. Used to render the leader
             narrower or wider.
                value:
                    point value, e. g. "5pt" -->
        <xsl:attribute name="leader-pattern-width">3pt</xsl:attribute>
        
        <!-- Alignment of the leaders. Only works with AntennaHouse Formatter
                value:
                    reference-area -->
        <xsl:attribute name="leader-alignment">reference-area</xsl:attribute>        

        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>        
        
    </xsl:attribute-set>
    
    <!-- Paragraph formats -->
    
    <!-- Edited volumes -->
    
    <!-- Monographs -->
    
    <xsl:attribute-set name="toc-format-part">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
        <!-- margins -->
        <xsl:attribute name="space-before">18pt</xsl:attribute><!-- Achtung, funktioniert nicht, wenn es am Kopf der Seite steht -->
        <xsl:attribute name="space-after">14pt</xsl:attribute><!-- Achtung, funktioniert nicht, wenn es am Kopf der Seite steht -->
    </xsl:attribute-set>

    <xsl:attribute-set name="toc-format-first-level">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_base"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">15pt</xsl:attribute>
        <!-- margins -->
        <xsl:attribute name="space-before">15pt</xsl:attribute><!-- Achtung, funktioniert nicht, wenn es am Kopf der Seite steht -->
        <xsl:attribute name="space-after">15pt</xsl:attribute><!-- Achtung, funktioniert nicht, wenn es am Kopf der Seite steht -->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="toc-format-levels-after-first">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_base"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">10.5pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">13pt</xsl:attribute>
        <!-- margins -->
        <xsl:attribute name="margin-top">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
    </xsl:attribute-set>    

    <!-- ***************************************************************************** -->
    <!--    Pagination of the book                                                     -->
    <!-- ***************************************************************************** -->
    <!--    values: 
                arabic       : arabic numbering
                roman-arabic : roman numbering for frontmatter, arabic for the rest   -->
    <xsl:variable name="pagination">arabic</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--    Chapter page handling                                                      -->
    <!-- ***************************************************************************** -->

    <!-- Defines if chapters generally start on a left (recto) page or not 
         Allowed values:
         auto        : Force the last page in this page-sequence to be an odd-page if 
                       the initial-page-number of the next page-sequence is even. Force 
                       it to be an even-page if the initial-page-number of the next 
                       page-sequence is odd. If there is no next page-sequence or if the 
                       value of its initial-page-number is "auto" do not force any page.
         even        : Force an even number of pages in this page-sequence.
         odd         : Force an odd number of pages in this page-sequence.
         end-on-even : Force the last page in this page-sequence to be an even-page.
         end-on-odd  : Force the last page in this page-sequence to be an odd-page.
         no-force    : Do not force either an even or an odd number of pages in this 
                       page-sequence                                                   -->
    <xsl:variable name="ChapterPageHandling">end-on-even</xsl:variable>

    <!-- Define if footnotes will be rendered as footnotes or endnotes.
        values:
            footnote                   : render as footnotes
            endnote_chapter_backmatter : endnote in chapter backmatter 
            endnote_book_backmatter    : endnotes in book backmatter -->
    <!-- TO DO: First chapter always starts with an odd page, last chapter always ends on an even page -->
    <xsl:variable name="FootnoteHandling">footnote</xsl:variable>

    <!-- Heading used for introduction of endnotes in the chapter backmatter.
         Only used if endnotes are activated. -->
    <xsl:variable name="heading_endnotes_chapter_backmatter_en">Endnotes</xsl:variable>
    <xsl:variable name="heading_endnotes_chapter_backmatter_de">Anmerkungen</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--   General fonts, font size and line height definition                         -->
    <!-- ***************************************************************************** -->

    <!-- Typography Classes (in pt.):
            Normal Text:    XS 9/11.5; S 9.5/12; M 10/13  ; L 10.5/13  ; XL 12/14.5
            Petit Text:     XS 8/10  ; S 8.5/11; M  9/11.5; L  9  /11.5; XL 11/13.5 -->

    <!-- Font Sizes -->
    <xsl:variable name="BaseFontSize">10.5pt</xsl:variable>
    <xsl:variable name="PetitFontSize">9pt</xsl:variable>
    
    <!-- Line Grid -->
    <xsl:variable name="LineGridNormal">13pt</xsl:variable>
    <xsl:variable name="LineGridPetit">11.5pt</xsl:variable>
        
    <!-- Fonts -->
    <xsl:variable name="general_font_family_base">Linux Libertine O</xsl:variable>
    <xsl:variable name="general_font_family_alternate">Linux Biolinum O</xsl:variable>
    
    <!-- Colors -->
    <xsl:variable name="general_font_color_base">#000000</xsl:variable><!-- Black -->
    <xsl:variable name="general_font_color_alternate">#ff8c00</xsl:variable><!-- Dark Orange -->

    <!-- ***************************************************************************** -->
    <!--    Handling of running titles                                                 -->
    <!-- ***************************************************************************** -->
    
    <!-- Maximum count of authors displayed in the running head of a proceedings book
         This is used to prevent running headers which are too long to display -->
    <xsl:variable name="Proceedings_Max_Authors_Running_Head_Left">4</xsl:variable>
    <!-- The string that appears between author names -->
    <xsl:variable name="Proceedings_Authors_Running_Head_Left_Divider">, </xsl:variable>
    <!-- et al. String -->
    <xsl:variable name="Proceedings_Authors_Running_Head_Left_etal"> et al.</xsl:variable>
    
    <!-- ***************************************************************************** -->
    <!--    Handling of footer (DOI and URN)                                           -->
    <!-- ***************************************************************************** -->
    <!--    values: 
                electronic : in electronic version only
                print      : in print version only
                both       : in electronic and print version
                none       : URN and DOI are not rendered -->
    <!-- For proceedings -->
    <xsl:variable name="display_doi_proceedings_first_page">both</xsl:variable>
    <xsl:variable name="display_urn_proceedings_first_page">both</xsl:variable>
    <!-- For monographs -->
    <xsl:variable name="display_doi_monograph_first_page">both</xsl:variable>
    <xsl:variable name="display_urn_monograph_first_page">both</xsl:variable>
    
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

    <!-- Eventuell Parameter für Nummerierung der Fußnoten: Buchweise, kapitelweise -->

    <!-- ***************************************************************************** -->
    <!-- Attribute sets for FO Formatter                                               -->
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
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
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
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!-- Paragraph                                                                     -->
    <!-- ***************************************************************************** -->
    
    <!-- Standard Paragraph -->
    <xsl:attribute-set name="paragraph_formats">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:attribute-set>
        
    <!-- Page number at the bottom of the page -->
    <xsl:attribute-set name="page_number_page_bottom">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Running Titles -->
    <xsl:attribute-set name="running_title_verso">
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="running_title_recto">
        <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:attribute-set>

    <!-- ***************************************************************************** -->
    <!--  Frontmatter styles                                                           -->
    <!-- ***************************************************************************** -->
    
    <xsl:attribute-set name="half-title">
        <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!--  Hyphenation                                                                  -->
    <!-- ***************************************************************************** -->
    
    <!-- Hypenate -->
    <xsl:attribute-set name="hyphenate">
        <xsl:attribute name="hyphenate">true</xsl:attribute>
        <!-- <xsl:attribute name="hyphenation-character">&#x2010;</xsl:attribute> --><!-- use the default character -->
        <xsl:attribute name="hyphenation-keep">auto</xsl:attribute>
        <xsl:attribute name="hyphenation-ladder-count">4</xsl:attribute>
        <xsl:attribute name="hyphenation-push-character-count">2</xsl:attribute>
        <xsl:attribute name="hyphenation-remain-character-count">2</xsl:attribute>       
        <xsl:attribute name="language">
            <xsl:value-of select="$MainLanguage"/>
        </xsl:attribute>       
    </xsl:attribute-set>
    
    <!-- Do not hyphenate -->
    <xsl:attribute-set name="do_not_hyphenate">
        <xsl:attribute name="hyphenate">false</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!--  Lists                                                                        -->
    <!-- ***************************************************************************** -->

    <xsl:attribute-set name="ul_1_block-level">
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">2mm</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:variable name="ul_symbol">&#x2013;</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--  Keeps                                                                        -->
    <!-- ***************************************************************************** -->
    
    <!-- Keep rules for standard paragraphs -->
    <xsl:attribute-set name="keeps-paragraph">
        <xsl:attribute name="orphans">1</xsl:attribute>
        <xsl:attribute name="widows">2</xsl:attribute>
        <xsl:attribute name="keep-with-next">auto</xsl:attribute>
        <xsl:attribute name="keep-with-previous">auto</xsl:attribute>        
    </xsl:attribute-set>

    <!-- Keep rules for headings -->
    <xsl:attribute-set name="keeps-headings">
        <xsl:attribute name="orphans">999</xsl:attribute>
        <xsl:attribute name="widows">999</xsl:attribute>
        <xsl:attribute name="keep-with-next">5</xsl:attribute>
        <xsl:attribute name="keep-with-previous">auto</xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!--  Indents                                                                      -->
    <!-- ***************************************************************************** -->
    
    <!-- First line indents for paragraphs -->
    <xsl:attribute-set name="indents-paragraph_first_line">
        <xsl:attribute name="text-indent">2em</xsl:attribute>
     </xsl:attribute-set>

    <!-- First line indents for paragraphs -->
    <xsl:attribute-set name="no_indents-paragraph_first_line">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Indents for disp-quote (block quotes) -->
    <xsl:attribute-set name="indents-disp-quote">
        <xsl:attribute name="start-indent">1em</xsl:attribute>
        <xsl:attribute name="end-indent">1em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Indents for bibliographic entries -->
    <!-- First entry in list -->
    <xsl:attribute-set name="no_indents_bibliographic_entry">
        <xsl:attribute name="space-before">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Follwing entries -->
    <xsl:attribute-set name="indents_bibliographic_entry">
        <xsl:attribute name="space-before">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
    </xsl:attribute-set>    
    
    <!-- Verse group  -->
    <xsl:attribute-set name="verse-group">
        <xsl:attribute name="space-after">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!--  Titles and Headings                                                          -->
    <!-- ***************************************************************************** -->
    
    <!-- Author names (proceedings only) -->
    <xsl:attribute-set name="fonts_author_names_chapter_head">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_base"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">11.5pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">small-caps</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">6mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- Divider of author names on title page -->
    <xsl:variable name="author-name-divider_chapter-head">&#x00A0;&#x2012;&#x0020;</xsl:variable>

    <!-- Chapter Title -->
    <xsl:attribute-set name="fonts_chapter_title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">22pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Chapter Subtitle -->
    <xsl:attribute-set name="fonts_chapter_subtitle">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
        <xsl:attribute name="space-before">1mm</xsl:attribute>
    </xsl:attribute-set>
   
    <!-- Margin between title block and text -->
    <xsl:attribute-set name="margin_under_title">
        <xsl:attribute name="space-after">14.5mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Heading 1 -->
    <xsl:attribute-set name="fonts_heading_1">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">17pt</xsl:attribute>
        <xsl:attribute name="space-before">9mm</xsl:attribute>
        <xsl:attribute name="space-after">4.5mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Heading 2 -->
    <xsl:attribute-set name="fonts_heading_2">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">16pt</xsl:attribute>
        <xsl:attribute name="space-before">9mm</xsl:attribute>
        <xsl:attribute name="space-after">4.5mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Heading 3 -->
    <xsl:attribute-set name="fonts_heading_3">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">16pt</xsl:attribute>
        <xsl:attribute name="space-before">5.5mm</xsl:attribute>
        <xsl:attribute name="space-after">3.5mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Heading 4 -->
    <xsl:attribute-set name="fonts_heading_4">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">11.5pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-variant">normal</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-before">5.5mm</xsl:attribute>
        <xsl:attribute name="space-after">3.5mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- ***************************************************************************** -->
    <!--  Table formats                                                                -->
    <!-- ***************************************************************************** -->
    
    <!-- Table margins -->
    <xsl:attribute-set name="table_margins">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$LineGridPetit"/>
        </xsl:attribute>        
    </xsl:attribute-set>
    
    <!-- ***************************************************************************** -->
    <!--  Character formats                                                            -->
    <!-- ***************************************************************************** -->
    
    <!-- Footnote reference number / Superscript -->
    <xsl:attribute-set name="footnote_reference_number">
        <xsl:attribute name="font-size">70%</xsl:attribute>
        <xsl:attribute name="baseline-shift">2.8pt</xsl:attribute>        
    </xsl:attribute-set>

    <!-- Subscript -->
    <xsl:attribute-set name="subscript">
        <xsl:attribute name="font-size">70%</xsl:attribute>
        <xsl:attribute name="baseline-shift">-2pt</xsl:attribute>        
    </xsl:attribute-set>

    <!-- Caption labels -->
    <xsl:attribute-set name="caption_labels">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$general_font_family_alternate"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Emphasis for cross references and hyperlinks; only for $medium='electronic' -->
    <!-- ATTENTION: Use formats with identical text flow only!!! -->
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

    <!-- ***************************************************************************** -->
    <!--  Publisher logo                                                               -->
    <!-- ***************************************************************************** -->
    
    <!-- Title page -->
    <xsl:variable name="pub-logo-main-title-xpos">64.5mm</xsl:variable>
    <xsl:variable name="pub-logo-main-title-ypos">180mm</xsl:variable>
    <xsl:variable name="pub-logo-main-title-width">40mm</xsl:variable>
    <xsl:variable name="pub-logo-main-title-height">26mm</xsl:variable>
    <xsl:variable name="pub-logo-main-title-fileref"> /home/wit/Arbeit/OMP/Heiup/Wintz/images/heiup/logos/Logo_UB_rgb.tif</xsl:variable>
    
</xsl:stylesheet>
