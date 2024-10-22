<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:pcom="http://cityehr/pdf/common"
  xmlns:com="http://cityehr/common"
  exclude-result-prefixes="xs pcom com ditaarch"
  version="2.0">
  
  <!--
    Generates FO code to produce a PDF from an LwDITA 'map'.
    
    Author: Adam Retter
  -->
  
  <xsl:import href="common.xslt"/>
  <xsl:import href="common-pdf.xslt"/>
  <xsl:import href="create-topic-pdf.xslt"/>
  
  <xsl:output encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
  
  <xsl:variable name="authors" as="xs:string+" select="('John Chelsom', 'Stephanie Cabrera', 'Catriona Hopper', 'Jennifer Ramirez')"/>
  <xsl:variable name="map-date" as="xs:date" select="xs:date('2023-08-05Z')"/>
  
  <xsl:template match="document-node()">
    <xsl:call-template name="pcom:fo-root"/>
  </xsl:template>
  
  <!-- PAGE METADATA -->
  <xsl:template match="map" mode="declarations">
    <xsl:call-template name="pcom:fo-declarations">
      <xsl:with-param name="title" select="topicmeta/navtitle"/>
      <xsl:with-param name="authors" select="$authors"/>
      <xsl:with-param name="description" select="doc(com:abs-uri(., topicref[1]/@href))/topic/body/p[1]"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- COVER PAGE HEADER -->
  <xsl:template match="/map/topicmeta" mode="cover-page-header">
    <fo:block/>
  </xsl:template>
  
  
  <!-- COVER PAGE FOOTER -->
  <xsl:template match="/map/topicmeta" mode="cover-page-footer">
    <fo:block/>
  </xsl:template>
  
  <!-- COVERPAGE SEQUENCE METADATA -->
  <xsl:template match="/map/topicmeta" mode="cover-page-sequence-setup">
    <fo:title><xsl:value-of select="navtitle"/></fo:title>
  </xsl:template>

  <!-- COVER PAGE -->
  <xsl:template match="map" mode="cover-page">
    <xsl:call-template name="pcom:cover-page">
      <xsl:with-param name="title" select="topicmeta/navtitle"/>
      <xsl:with-param name="sub-title">Open Health Informatics</xsl:with-param>
      <xsl:with-param name="authors" select="$authors"/>
      <xsl:with-param name="date" select="$map-date"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- TOPIC - each is loaded from a 'topicref/@href' and processed -->
  <xsl:template match="topicref" mode="topic-pages">
    <xsl:apply-templates select="doc(com:abs-uri(., @href))/topic" mode="topic-pages"/>
  </xsl:template>
  
  
  <!-- NOTE(AR): left here to assist with debugging -->
  <!--
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  -->
  
</xsl:stylesheet>