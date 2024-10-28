<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:com="http://cityehr/common"
  xmlns:hcom="http://cityehr/html/common"
  exclude-result-prefixes="xs hcom"
  version="2.0">
  
  <!--
    Common code for generating a HTML page from an LwDITA 'topic' or 'map'.
    
    Author: Adam Retter
  -->
  
  <xsl:import href="common.xslt"/>

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

  <!-- TOC (Table of Contents) -->
  <xsl:template name="hcom:toc">
    <xsl:param name="sections" as="element()+"/>
    <ol class="toc" style="list-style-type: none;">
      <xsl:for-each select="$sections">
        <xsl:variable name="section" select="if (local-name(.) eq 'topicref') then com:get-topic(., .) else ."/>
        <xsl:call-template name="hcom:toc-entry">
          <xsl:with-param name="section" select="$section"/>
          <xsl:with-param name="level">1</xsl:with-param>
          <xsl:with-param name="numbers" select="position()"/>
          <xsl:with-param name="page-url" select="hcom:dita-filename-to-html(@href)"/>
        </xsl:call-template>
      </xsl:for-each>
    </ol>
  </xsl:template>

  <!-- Entry in the TOC (Table of Contents) -->
  <xsl:template name="hcom:toc-entry">
    <xsl:param name="section"   as="element()"    required="yes"/>
    <xsl:param name="level"     as="xs:integer"   required="yes"/>
    <xsl:param name="numbers"   as="xs:integer*"  required="no"/>
    <xsl:param name="page-url"  as="xs:string?"   required="yes"/>

    <xsl:variable name="section-id" select="generate-id($section)"/>

    <!-- section -->
    <li><xsl:value-of select="string-join($numbers, '.')"/><xsl:text>. </xsl:text><a name="{$section-id}" href="{$page-url}"><xsl:value-of select="$section/title"/></a></li>

    <!-- then process sub sections recursively (no more than 4 levels deep!) -->
    <xsl:if test="$level le 4">
      <ol style="list-style-type: none;">
        <xsl:for-each select="$section/body/section|$section/section">
          <xsl:call-template name="hcom:toc-entry">
            <xsl:with-param name="section"  select="."/>
            <xsl:with-param name="level"    select="$level + 1"/>
            <xsl:with-param name="numbers"  select="($numbers, position())"/>
            <xsl:with-param name="page-url" select="string-join(($page-url, @id), '#')"/>
          </xsl:call-template>
        </xsl:for-each>
      </ol>
    </xsl:if>
  </xsl:template>

  <!--
    Changes a DITA filename to a HTML filename, e.g. 'thing.dita' -> 'thing.html'  
  -->
  <xsl:function name="hcom:dita-filename-to-html" as="xs:string">
    <xsl:param name="dita-filename" as="xs:string" required="yes"/>
    <xsl:sequence select="replace($dita-filename, '\.dita(map)?$', '.html')"/>
  </xsl:function>
  
</xsl:stylesheet>