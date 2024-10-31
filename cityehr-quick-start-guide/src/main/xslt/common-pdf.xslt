<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:x="adobe:ns:meta/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xmp="http://ns.adobe.com/xap/1.0/"
  xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
  xmlns:pcom="http://cityehr/pdf/common"
  xmlns:com="http://cityehr/common"
  exclude-result-prefixes="xs pcom com"
  version="2.0">
  
  <!--
    Common FO code for generating a PDF from an LwDITA 'topic' or 'map'.
    
    Author: Adam Retter
  -->
  
  <xsl:import href="common.xslt"/>
  
  <xsl:template name="pcom:fo-root">
    <fo:root xml:lang="en" font-family="Arial,Helvetica,sans-serif" font-size="11pt">
      <xsl:call-template name="pcom:fo-layout-master-set"/>

      <xsl:apply-templates mode="declarations"/>

      <xsl:call-template name="pcom:page-sequences"/>
      
      <xsl:call-template name="pcom:last-page"/>
    </fo:root>
  </xsl:template>
  
  <xsl:template name="pcom:fo-layout-master-set">
    <fo:layout-master-set>
      <!-- NOTE(AR): A4 print size -->
      <fo:simple-page-master master-name="PageMaster" page-height="297mm" page-width="210mm" margin-top="10mm" margin-left="20mm" margin-right="20mm" margin-bottom="10mm">
        <fo:region-body margin-top="36pt" margin-bottom="36pt"/>
        <fo:region-before extent="20pt"/>
        <fo:region-after extent="20pt"/>
      </fo:simple-page-master>
    </fo:layout-master-set>
  </xsl:template>
  
  <xsl:template name="pcom:fo-declarations">
    <xsl:param name="title"       as="xs:string"    required="yes"/>
    <xsl:param name="authors"     as="xs:string+"   required="yes"/>
    <xsl:param name="description" as="xs:string?"   required="no"/>
    <xsl:param name="keywords"    as="xs:string?"   required="no"/>
    <xsl:param name="creator"     as="xs:string"    required="no" select="'XSLT 2.0'"/>
    <xsl:param name="producer"    as="xs:string?"   required="no"/>
    <xsl:param name="created"     as="xs:dateTime"  required="no" select="current-dateTime()"/>
    <xsl:param name="modified"    as="xs:dateTime"  required="no" select="current-dateTime()"/> 
    <fo:declarations>
      <x:xmpmeta>
        <rdf:RDF>
          <rdf:Description rdf:about="">
            <dc:title><xsl:value-of select="$title"/></dc:title>
            <dc:creator><xsl:value-of select="com:format-inline-text-list($authors)"/></dc:creator>
            <xsl:if test="$description">
              <dc:description><xsl:value-of select="$description"/></dc:description>
            </xsl:if>
            <xsl:if test="$keywords">
              <pdf:Keywords><xsl:value-of select="$keywords"/></pdf:Keywords>
            </xsl:if>
            <xmp:CreatorTool><xsl:value-of select="$creator"/></xmp:CreatorTool>
            <xsl:if test="$producer">
              <pdf:Producer><xsl:value-of select="$producer"/></pdf:Producer>
            </xsl:if>
            <xmp:CreationDate><xsl:value-of select="pcom:iso8601-dateTime-utc($created)"/></xmp:CreationDate>
            <xmp:ModifyDate><xsl:value-of select="pcom:iso8601-dateTime-utc($modified)"/></xmp:ModifyDate>
          </rdf:Description>
        </rdf:RDF>
      </x:xmpmeta>
    </fo:declarations>
  </xsl:template>
  
  <xsl:template name="pcom:page-sequences">
    <xsl:apply-templates select="map" mode="cover-page"/>
    <xsl:apply-templates select="map" mode="toc"/>
    <xsl:apply-templates select="topic|map/topicref" mode="topic-pages"/>
  </xsl:template>
  
  <xsl:template name="pcom:topic-pages">
    <fo:page-sequence master-reference="PageMaster" id="topic-page-sequence-{generate-id()}">
      <xsl:apply-templates select="." mode="page-sequence-setup"/>
      <fo:static-content flow-name="xsl-region-before">
        <fo:block-container height="100%" display-align="before">
          <xsl:apply-templates select="." mode="header"/>
        </fo:block-container>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block-container height="100%" display-align="after">
          <xsl:apply-templates select="." mode="footer"/>
        </fo:block-container>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body" hyphenate="true">
        <xsl:apply-templates select="." mode="body"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
  <!-- COVER PAGE -->
  <xsl:template name="pcom:cover-page">
    <xsl:param name="title" as="xs:string" required="yes"/>
    <xsl:param name="sub-title" as="xs:string?" required="no"/>
    <xsl:param name="authors" as="xs:string+" required="yes"/>
    <xsl:param name="date" as="xs:date" required="no" select="current-date()"/>
    <fo:page-sequence master-reference="PageMaster" id="cover-page-sequence">
      <xsl:apply-templates mode="cover-page-sequence-setup"/>
      <fo:static-content flow-name="xsl-region-before">
        <fo:block-container height="100%" display-align="before">
          <xsl:apply-templates mode="cover-page-header"/>
        </fo:block-container>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block-container height="100%" display-align="after">
          <xsl:apply-templates mode="cover-page-footer"/>
        </fo:block-container>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body" hyphenate="true">
        <fo:block text-align="center" margin-top="20pt">
          <fo:external-graphic src="{com:abs-uri(., 'images/cityehr-logo.png')}" content-height="scale-to-fit" content-width="scale-to-fit" width="100%" scaling="uniform"/>
        </fo:block>
        <fo:block background-color="#A42420" color="#FFFFFF" text-align="right" display-align="center" margin-top="200pt" padding-top="7pt" padding-right="7pt" padding-bottom="7pt">
          <fo:block font-size="14pt"><xsl:value-of select="$title"/></fo:block>
          <fo:block font-size="14pt"><xsl:value-of select="$sub-title"/></fo:block>
          <fo:block font-size="12pt"><xsl:value-of select="com:format-inline-text-list($authors)"/></fo:block>
          <fo:block font-size="12pt"><xsl:value-of select="pcom:simple-date-utc($date)"/></fo:block>          
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <!-- TOC (Table of Contents) -->
  <xsl:template name="pcom:toc">
    <xsl:param name="sections" as="element()+"/>
    <fo:page-sequence master-reference="PageMaster" id="toc-sequence">
      <fo:title>Table of Contents</fo:title>
      <fo:flow flow-name="xsl-region-body" hyphenate="true">
        <fo:block background-color="#A42420" color="#FFFFFF" font-weight="bold" font-size="14pt" display-align="center" margin-bottom="11pt" id="toc-{generate-id()}">
          <fo:block margin-left="8pt">Table of Contents</fo:block>
        </fo:block>
        <xsl:for-each select="$sections">
          <xsl:variable name="section" select="if (local-name(.) eq 'topicref') then com:get-topic(., .) else ."/>
          <xsl:call-template name="pcom:toc-entry">
            <xsl:with-param name="section" select="$section"/>
            <xsl:with-param name="level">1</xsl:with-param>
            <xsl:with-param name="numbers" select="position()"/>
          </xsl:call-template>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <!-- Entry in the TOC (Table of Contents) -->
  <xsl:template name="pcom:toc-entry">
    <xsl:param name="section"          as="element()"  required="yes"/>
    <xsl:param name="level"            as="xs:integer" required="yes"/>
    <xsl:param name="numbers"          as="xs:integer*"  required="no"/>

    <xsl:variable name="section-id" select="generate-id($section)"/>

    <!-- section -->
    <fo:block text-align-last="justify">
      <fo:basic-link internal-destination="section-{$section-id}" padding-left="{33 * ($level - 1)}pt">
        <xsl:value-of select="string-join($numbers, '.')"/>
        <!-- xsl:number level="single" count="$sections"/ -->
        <xsl:text>. </xsl:text><xsl:value-of select="$section/title"/>
        <fo:leader leader-length.minimum="12pt" leader-length.optimum="40pt" leader-length.maximum="100%" leader-pattern="dots"/>
        <xsl:text> </xsl:text>
        <fo:page-number-citation ref-id="section-{$section-id}"/>
      </fo:basic-link>
    </fo:block>
    <!-- then process sub sections recursively (no more than 4 levels deep!) -->
    <xsl:if test="$level le 4">
      <xsl:for-each select="$section/body/section|$section/section">
        <xsl:call-template name="pcom:toc-entry">
          <xsl:with-param name="section" select="."/>
          <xsl:with-param name="level" select="$level + 1"/>
          <xsl:with-param name="numbers" select="($numbers, position())"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- LAST PAGE -->
  <xsl:template name="pcom:last-page">  
    <fo:page-sequence master-reference="PageMaster" id="last-page">
      <!-- TODO(AR) should we add some content to the last page? -->
      <!--
      <fo:static-content flow-name="xsl-region-before">
        <fo:block-container height="100%" display-align="before">
          <xsl:apply-templates select="." mode="header"/>
        </fo:block-container>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block-container height="100%" display-align="after">
          <xsl:apply-templates select="." mode="footer"/>
        </fo:block-container>
      </fo:static-content>
      -->
      <fo:flow flow-name="xsl-region-body" hyphenate="true">
        <fo:block id="endofdoc"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
  <!--
    Adjust a dateTime to UTC timezone and then formats it as
    ISO-8601 format.
  -->
  <xsl:function name="pcom:iso8601-dateTime-utc" as="xs:string">
    <xsl:param name="dateTime" as="xs:dateTime" required="yes"/>
    <xsl:sequence select="format-dateTime(adjust-dateTime-to-timezone($dateTime, xs:dayTimeDuration('PT0H')), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z')"/>
  </xsl:function>
  
  <!--
    Adjust a date to UTC timezone and then formats it as
    nth Month Year.
  -->
  <xsl:function name="pcom:simple-date-utc" as="xs:string">
    <xsl:param name="date" as="xs:date" required="yes"/>
    <xsl:sequence select="format-date(adjust-date-to-timezone($date, xs:dayTimeDuration('PT0H')), '[D1o] [MNn] [Y0001]')"/>
  </xsl:function>

</xsl:stylesheet>