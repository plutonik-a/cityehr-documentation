<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:x="adobe:ns:meta/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xmp="http://ns.adobe.com/xap/1.0/"
  xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
  xmlns:com="http://cityehr/pdf/common"
  exclude-result-prefixes="xs com"
  version="2.0">
  
  <!--
    Common FO code for generating a PDF from an LwDITA 'topic' or 'map'.
    
    Author: Adam Retter
  -->
  
  <xsl:template name="com:fo-root">
    <xsl:param name="page-sequence-id" required="no" select="generate-id()"/>

    <fo:root xml:lang="en" font-family="Arial,Helvetica,sans-serif" font-size="11pt">
      <xsl:call-template name="com:fo-layout-master-set"/>

      <xsl:apply-templates mode="declarations"/>

      <xsl:call-template name="com:page-sequence">
        <xsl:with-param name="page-sequence-id" select="$page-sequence-id"/>
      </xsl:call-template>      
    </fo:root>
  </xsl:template>
  
  <xsl:template name="com:fo-layout-master-set">
    <fo:layout-master-set>
      <fo:simple-page-master page-height="297mm" page-width="210mm" margin-top="10mm" margin-left="20mm" margin-right="20mm" margin-bottom="10mm" master-name="PageMaster">
        <fo:region-body margin-top="36pt" margin-bottom="36pt"/>
        <fo:region-before extent="20pt"/>
        <fo:region-after extent="20pt"/>
      </fo:simple-page-master>
    </fo:layout-master-set>
  </xsl:template>
  
  <xsl:template name="com:fo-declarations">
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
            <xmp:CreationDate><xsl:value-of select="com:iso8601-dateTime-utc($created)"/></xmp:CreationDate>
            <xmp:ModifyDate><xsl:value-of select="com:iso8601-dateTime-utc($modified)"/></xmp:ModifyDate>
          </rdf:Description>
        </rdf:RDF>
      </x:xmpmeta>
    </fo:declarations>
  </xsl:template>
  
  <xsl:template name="com:page-sequence">
    <xsl:param name="page-sequence-id" required="yes"/>
    <fo:page-sequence master-reference="PageMaster" id="{$page-sequence-id}">
      <xsl:apply-templates mode="page-sequence-setup"/>
      <fo:static-content flow-name="xsl-region-before">
        <fo:block-container height="100%" display-align="before">
          <xsl:apply-templates mode="header"/>
        </fo:block-container>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block-container height="100%" display-align="after">
          <xsl:apply-templates mode="footer"/>
        </fo:block-container>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body" hyphenate="true">
        <xsl:apply-templates mode="body"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <!--
    Creates a comman and (finally) 'and' separated list, includes an Oxford comma before the 'and'.
    e.g. ('a', 'b', 'c') => 'a, b, and c'
  -->
  <xsl:function name="com:format-inline-text-list" as="xs:string?">
    <xsl:param name="items" as="xs:string*" required="yes"/>
    <xsl:sequence select="replace(string-join($items, ', '), '^(.+,)\s([^,]+)$', '$1 and $2')"/>
  </xsl:function>
  
  <!--
    Adjust a dateTime to UTC timezone and then formats it as
    ISO-8601 format.
  -->
  <xsl:function name="com:iso8601-dateTime-utc" as="xs:string">
    <xsl:param name="dateTime" as="xs:dateTime" required="yes"/>
    <xsl:sequence select="format-dateTime(adjust-dateTime-to-timezone($dateTime, xs:dayTimeDuration('PT0H')), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z')"/>
  </xsl:function>

</xsl:stylesheet>