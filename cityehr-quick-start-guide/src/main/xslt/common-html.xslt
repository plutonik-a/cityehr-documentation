<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:hcom="http://cityehr/html/common"
  exclude-result-prefixes="xs hcom"
  version="2.0">
  
  <!--
    Common code for generating a HTML page from an LwDITA 'topic' or 'map'.
    
    Author: Adam Retter
  -->
  
  <xsl:template name="hcom:meta">
    <xsl:param name="authors" as="xs:string+" required="yes"/>
    <xsl:param name="created-date" as="xs:date?" required="no"/>
    <xsl:param name="modified-date" as="xs:date?" required="no"/>
    <xsl:apply-templates select="topicmeta|title" mode="metadata"/>
    <xsl:call-template name="hcom:authors-meta">
      <xsl:with-param name="authors" select="$authors"/>
    </xsl:call-template>
    <link rel="schema.DCTERMS" href="http://purl.org/dc/terms/"/>
    <meta name="DCTERMS.creator" content="https://seveninformatics.com"/>
    <xsl:if test="exists($created-date)">
      <meta name="DCTERMS.created" content="{$created-date}"/>
    </xsl:if>
    <xsl:if test="exists($modified-date)">
      <meta name="DCTERMS.modified" content="{$modified-date}"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="hcom:authors-meta">
    <xsl:param name="authors" as="xs:string+" required="yes"/>
    <xsl:for-each select="$authors">
      <meta name="author" content="{.}"/>
    </xsl:for-each>
  </xsl:template>
  
  <!--
    Changes a DITA filename to a HTML filename, e.g. 'thing.dita' -> 'thing.html'  
  -->
  <xsl:function name="hcom:dita-filename-to-html" as="xs:string">
    <xsl:param name="dita-filename" as="xs:string" required="yes"/>
    <xsl:sequence select="replace($dita-filename, '\.dita(map)?$', '.html')"/>
  </xsl:function>
  
</xsl:stylesheet>