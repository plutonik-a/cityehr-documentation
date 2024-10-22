<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:hcom="http://cityehr/html/common"
  xmlns:com="http://cityehr/common"
  exclude-result-prefixes="xs hcom com"
  version="2.0">
  
  <!--
    Generates a simple HTML website from an LwDITA 'map'.
    Author: Adam Retter
  -->
  
  <xsl:import href="common.xslt"/>
  <xsl:import href="common-html.xslt"/>
  <xsl:import href="create-topic-html.xslt"/>
  
  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
  
  <!-- PARAMETER - the path to the folder where you want to output the Topic HTML files -->
  <xsl:param name="output-folder" as="xs:string" select="com:parent-path(com:document-uri(/map))"/>
  
  <!-- PARAMETER - specifing a PDF file version of this to present a download link for -->
  <xsl:param name="download-pdf-filename" as="xs:string?"/>
  
  <xsl:variable name="authors" as="xs:string+" select="('John Chelsom', 'Stephanie Cabrera', 'Catriona Hopper', 'Jennifer Ramirez')"/>
  <xsl:variable name="map-date" as="xs:date" select="xs:date('2023-08-05Z')"/>
  
  <xsl:template match="map">
    <html>
      <head>
        <xsl:call-template name="hcom:meta">
          <xsl:with-param name="authors" select="$authors"/>
          <xsl:with-param name="created-date" select="$map-date"/>
          <xsl:with-param name="modified-date" select="$map-date"/>
        </xsl:call-template>
      </head>
      <body>
        <article>
          <time datetime="{$map-date}" pubdate="pubdate"></time>
          <xsl:apply-templates select="topicmeta" mode="body"/>
          <xsl:if test="exists($download-pdf-filename)">
            <div id="download-pdf-version"><a href="{$download-pdf-filename}">Download PDF version</a></div>
          </xsl:if>
          <secton>
            <h2>Table of Contents</h2>
            <ol class="toc">
              <xsl:apply-templates select="topicref" mode="create-topic-html"/>
              <xsl:apply-templates select="topicref" mode="toc"/>
            </ol>
          </secton>
        </article>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="topicmeta" mode="metadata body">
    <xsl:apply-templates select="navtitle" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="navtitle" mode="metadata">
    <title><xsl:value-of select="."/></title>
  </xsl:template>
  
  <xsl:template match="navtitle" mode="body">
    <h1><xsl:value-of select="."/></h1>
  </xsl:template>
  
  <!-- Create a new HTML file for each topic that is referenced -->
  <xsl:template match="topicref" mode="create-topic-html">
    <xsl:result-document href="file://{$output-folder}/{hcom:dita-filename-to-html(@href)}">
      <xsl:apply-templates select="doc(com:abs-uri(., @href))/topic"/>
    </xsl:result-document>
  </xsl:template>
  
  <!-- Put an entry in the Table of Contents for each topic that is referenced -->
  <xsl:template match="topicref" mode="toc">
    <li><a href="{hcom:dita-filename-to-html(@href)}"><xsl:value-of select="doc(com:abs-uri(., @href))/topic/title"/></a></li>
  </xsl:template>
  
</xsl:stylesheet>