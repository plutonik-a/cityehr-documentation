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
    Generates FO code to produce a PDF from an LwDITA 'topic'.
    
    Author: Adam Retter
  -->
  
  <xsl:import href="common.xslt"/>
  <xsl:import href="common-pdf.xslt"/>
  
  <xsl:output encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:variable name="authors" as="xs:string+" select="('John Chelsom', 'Stephanie Cabrera', 'Catriona Hopper', 'Jennifer Ramirez')"/>

  <xsl:template match="document-node()">
    <xsl:call-template name="pcom:fo-root"/>
  </xsl:template>
  
  <!-- PAGE METADATA -->
  <xsl:template match="topic" mode="declarations">
    <xsl:call-template name="pcom:fo-declarations">
      <xsl:with-param name="title" select="title"/>
      <xsl:with-param name="authors" select="$authors"/>
      <xsl:with-param name="description" select="p[1]"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- PAGES -->
  <xsl:template match="topic" mode="topic-pages">
    <xsl:call-template name="pcom:topic-pages"/>
  </xsl:template>
  
  <!-- PAGE HEADER -->
  <xsl:template match="topic" mode="header">
    <fo:block text-align="center" font-size="10pt">
      <fo:block border-after-style="solid" border-after-width="0.75pt">cityEHR Quick Start Guide</fo:block>
    </fo:block>
  </xsl:template>
  
  <!-- PAGE FOOTER -->
  <xsl:template match="topic" mode="footer">
    <fo:block text-align-last="justify" font-size="10pt" border-style="solid" border-width="0.75pt" display-align="center">
      <fo:block margin-left="8pt" margin-right="8pt">
        <fo:inline>cityEHR Quick Start Guide</fo:inline>
        <fo:leader leader-pattern="space"/>
        <fo:inline>Page <fo:page-number/> of <fo:page-number-citation ref-id="endofdoc"/></fo:inline>
      </fo:block>
    </fo:block>
  </xsl:template>
  
  <!-- PAGE SEQUENCE METADATA -->
  <xsl:template match="topic" mode="page-sequence-setup">
    <fo:title><xsl:value-of select="title"/></fo:title>
  </xsl:template>

  <!-- PAGE CONTENT HEADER -->
  <xsl:template match="topic" mode="body">
    <fo:block background-color="#B84747" color="#FFFFFF" font-weight="bold" font-size="14pt" display-align="center" margin-bottom="11pt" id="section-{generate-id()}">
      <fo:block margin-left="8pt"><xsl:value-of select="title"/></fo:block>
    </fo:block>
    <xsl:apply-templates select="body" mode="body"/>
  </xsl:template>
  

  <!-- PAGE CONTENT -->

  <xsl:template match="body" mode="body">
    <fo:block id="body-{generate-id()}">
      <xsl:apply-templates select="p|section" mode="body"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="section" mode="body">
    <fo:block background-color="#F17C7C" color="#FFFFFF" font-weight="bold" font-size="10pt" display-align="center" margin-bottom="11pt" id="section-{generate-id()}">
      <fo:block margin-left="8pt"><xsl:value-of select="title"/></fo:block>
    </fo:block>
    <xsl:apply-templates select="p|b|i|ol|ul|li|image|section" mode="body"/>
  </xsl:template>

  <xsl:template match="p" mode="body">
    <fo:block space-after="4pt"> <!-- NOTE(AR): 4pt spacing after each paragraph -->
      <xsl:apply-templates select="node()" mode="body"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="i|em" mode="body">
    <fo:inline font-style="italic"><xsl:apply-templates select="node()" mode="body"/></fo:inline>
  </xsl:template>
  
  <xsl:template match="b|strong" mode="body">
    <fo:inline font-weight="bold"><xsl:apply-templates select="node()" mode="body"/></fo:inline>
  </xsl:template>
  
  <xsl:template match="image" mode="body">
    <fo:block>
      <fo:external-graphic src="{com:abs-uri(., @href)}" width="100%" content-height="100%" content-width="scale-to-fit" scaling="uniform"/>
      <xsl:apply-templates select="alt" mode="body"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="ol" mode="body">
    <fo:list-block padding="4pt" margin-left="10pt" margin-top="11pt">
      <xsl:apply-templates select="li" mode="body-ol"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="li" mode="body-ol">
    <fo:list-item margin-left="10pt" margin-top="11pt" margin-right="33pt">
      <fo:list-item-label end-indent="label-end()">
        <fo:block><xsl:value-of select="position()"/><xsl:text>. </xsl:text></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block margin-left="10pt">
          <xsl:apply-templates select="element()" mode="body"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="ul" mode="body">
    <fo:list-block padding="4pt" margin-left="10pt" margin-top="11pt">
      <xsl:apply-templates select="li" mode="body-ul"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="li" mode="body-ul">
    <fo:list-item margin-left="10pt" margin-top="11pt" margin-right="33pt">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block margin-left="10pt">
          <xsl:apply-templates select="element()" mode="body"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="alt" mode="body">
    <fo:block font-size="9pt"><xsl:value-of select="."/></fo:block>
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
