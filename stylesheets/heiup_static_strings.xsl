<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">

    <!-- ***************************************************************************** -->
    <!-- This xsl stylesheet contains static strings which are added while typesetting -->
    <!-- Contact: Frank Krabbes, krabbes@ub.uni-heidelberg.de                          -->
    <!-- ***************************************************************************** -->
    <!-- Languages supported: German, English US                                       -->


    <!-- ***************************************************************************** -->
    <!--  G E R M A N                                                                  -->
    <!-- ***************************************************************************** -->

    <!-- PDF bookmark string for "Frontmatter" -->
    
    <xsl:variable name="de_frontmatter">Titelei</xsl:variable>

    <!-- 1. Series title page (frontmatter page ii - half title verso page) -->

    <xsl:variable name="de_SeriesEditors">Reihenherausgeber:</xsl:variable>

    <!-- 2. Main title page (frontmatter page iii) -->

    <!-- Separators for multiple author/editor names including all spaces:
        "Peter Schmidt, Heinz Becker und Gabi Geist" -->
    <xsl:variable name="de_Separator">, </xsl:variable>
    <xsl:variable name="de_LastSeparator"> und </xsl:variable>
    <!-- Edited volumes: "Herausgegeben von Gabi Geist" -->
    <xsl:variable name="de_Editor">Herausgegeben von </xsl:variable>

    <!-- 3. Impressum page (frontmatter page iv) -->

    <xsl:variable name="de_DNB">
        <fo:block font-weight="bold">Bibliografische Information der Deutschen
            Nationalbibliothek</fo:block>
        <fo:block>Die Deutsche Bibliothek verzeichnet diese Publikation in der Deutschen
            Nationalbibliografie. Detaillierte bibliografische Daten sind im Internet 
            unter <fo:basic-link external-destination="http://dnb.ddb.de"><fo:inline keep-together.within-line="always">http://dnb.ddb.de</fo:inline></fo:basic-link> abrufbar.</fo:block>
    </xsl:variable>
    <xsl:variable name="de_Availability">Die Online-Version dieser Publikation ist auf den
        Verlagswebseiten von HEIDELBERG UNIVERSITY PUBLISHING <fo:basic-link external-destination="http://heiup.uni-heidelberg.de"><fo:inline keep-together.within-line="always">http://heiup.uni-heidelberg.de</fo:inline></fo:basic-link>
        dauerhaft frei verfügbar (open access).</xsl:variable>
    <xsl:variable name="de_Hardcover"> (Gebundene Buchausgabe)</xsl:variable>
    <xsl:variable name="de_Softcover"> (Broschierte Buchausgabe)</xsl:variable>
    <xsl:variable name="de_PDF"> (PDF)</xsl:variable>
    <xsl:variable name="de_Print"> (Print)</xsl:variable>
    <xsl:variable name="de_eISSN"> (eISSN)</xsl:variable>
    <xsl:variable name="de_ISBN">ISBN </xsl:variable>
    <xsl:variable name="de_ISSN">ISSN </xsl:variable>
    <xsl:variable name="de_doi">doi: </xsl:variable>

    <xsl:variable name="de_toc-title">Inhaltsverzeichnis</xsl:variable>    

    <!-- ***************************************************************************** -->
    <!--  E N G L I S H, U S                                                           -->
    <!-- ***************************************************************************** -->

    <xsl:variable name="en_us_frontmatter">Frontmatter</xsl:variable>

    <!-- 1. Title page -->

    <!-- Separators for multiple author/editor names including all spaces:
        "Peter Schmidt, Heinz Becker, and Gabi Geist" -->
    <xsl:variable name="en_us_Separator">, </xsl:variable>
    <xsl:variable name="en_us_LastSeparator">, and </xsl:variable>
    <!-- Edited volumes: "Edited by Gabi Geist" -->
    <xsl:variable name="en_us_Editor">Edited by </xsl:variable>

    <!-- 2. Reihentitelseite / Titelei ii -->
    <xsl:variable name="en_us_SeriesEditors">Series Editors:</xsl:variable>
    
    <!-- 3. Impressum page -->
    
    <xsl:variable name="en_us_DNB">
        <fo:block font-weight="bold">Bibliographic information published by the Deutsche Nationalbibliothek</fo:block>
        <fo:block>The Deutsche Nationalbibliothek lists this publication in the Deutsche
            Nationalbibliografie. Detailed bibliographic data are available on the Internet 
            at <fo:basic-link external-destination="http://dnb.ddb.de"><fo:inline keep-together.within-line="always">http://dnb.ddb.de</fo:inline></fo:basic-link>.</fo:block>
    </xsl:variable>
    <xsl:variable name="en_us_Availability">The electronic, open access version of this work is
        permanently available on Heidelberg University Publishing’s website:
        <fo:basic-link external-destination="http://heiup.uni-heidelberg.de"><fo:inline keep-together.within-line="always">http://heiup.uni-heidelberg.de</fo:inline></fo:basic-link>.</xsl:variable>
    <xsl:variable name="en_us_Hardcover"> (Hardcover)</xsl:variable>
    <xsl:variable name="en_us_Softcover"> (Softcover)</xsl:variable>
    <xsl:variable name="en_us_PDF"> (PDF)</xsl:variable>
    <xsl:variable name="en_us_Print"> (Print)</xsl:variable>
    <xsl:variable name="en_us_eISSN"> (eISSN)</xsl:variable>
    <xsl:variable name="en_us_ISBN">ISBN </xsl:variable>
    <xsl:variable name="en_us_ISSN">ISSN </xsl:variable>
    <xsl:variable name="en_us_doi">doi:</xsl:variable>

    <xsl:variable name="en_us_toc-title">Table of Contents</xsl:variable>

    <!-- ***************************************************************************** -->
    <!--  L A N G U A G E   N E U T R A L                                              -->
    <!-- ***************************************************************************** -->
    
    <!-- cc logo -->
    
    <xsl:variable name="cc_by_sa_logo">
        <fo:external-graphic height="16pt" width="auto" content-height="16pt" content-width="auto" src="url('http://mirrors.creativecommons.org/presskit/buttons/88x31/png/by-sa.png')"/>
    </xsl:variable>

</xsl:stylesheet>
