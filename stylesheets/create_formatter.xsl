<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="stylesheet" as="xs:string" required="yes"/>
    
    <!-- Include stylesheet -->
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    
    <!-- Identity template : copy all text nodes, elements and attributes -->   
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="processing-instruction('include')">
        <xsl:element name="xsl:include">
            <xsl:attribute name="href">
                <xsl:value-of select="$stylesheet"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- to be deleted in the final version -->
    <xsl:template match="xsl:include">
        <xsl:if test="not(@href=$stylesheet)">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>