<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="UTF-8" media-type="text/x-json"/>
    <xsl:strip-space elements="*"/>
    
    
    <xsl:template match="DocumentSummarySet">
        <xsl:text>{</xsl:text>
        <xsl:text>"results" : </xsl:text><xsl:value-of select="count(DocumentSummary)"/>
        <xsl:if test="DocumentSummary">
            <xsl:text> , "DocumentSummaries" : </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:for-each select="DocumentSummary">
                <xsl:text>{ </xsl:text>
                <xsl:text> "uid" : </xsl:text><xsl:value-of select="@uid"/><xsl:text> , </xsl:text>
                <xsl:apply-templates/>
                <xsl:text> }</xsl:text>
                <xsl:if test="following-sibling::node()">
                    <xsl:text> , </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="node()" name="node">
        <xsl:param name="turnoffcomma">false</xsl:param>
        <xsl:choose>
            <xsl:when test="not(text())">
                <xsl:choose>
                    <xsl:when test="not(node())">  <!-- When there is no child -->
                        <xsl:text> "</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>" : "" </xsl:text>
                    </xsl:when>
                    <xsl:otherwise> <!-- when there are children -->
                        <xsl:text> "</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>" : [ </xsl:text>
                        <xsl:for-each select="node()">
                            <xsl:call-template name="inArray"/>
                        </xsl:for-each>
                        <xsl:text> ] </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string(number(.))!='NaN'">
                        <xsl:text> "</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>" : </xsl:text>
                        <xsl:value-of select="translate(normalize-space(.),'&#9;&#10;','&#x160;')"/>
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> "</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>" : "</xsl:text>
                        <xsl:value-of select="translate(normalize-space(.),'&#9;&#10;','&#x160;')"/>
                        <xsl:text>" </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::node() and $turnoffcomma = 'false'">
            <xsl:text> , </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="inArray">
        <xsl:text> { </xsl:text>
        <xsl:choose>
            <xsl:when test="count(node()) = 1">
                <xsl:call-template name="node">
                    <xsl:with-param name="turnoffcomma">true</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="node()">
                    <xsl:call-template name="node"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> } </xsl:text>
        <xsl:if test="following-sibling::node()">
            <xsl:text> , </xsl:text>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
