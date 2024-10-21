<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!--
    Splits a single file containing an LwDITA 'topic'
    into multiple files. Each 'section' in the input 'topic' file
    becomes its own 'topic; in its own output file.
    
    We also generate a LwDITA 'map' that links together all the topics.
    
    Author: Adam Retter
  -->
  
  <xsl:output indent="no"/>
  
  <!-- PARAMETER - the path to the folder where you want to output the Map and Topics -->
  <xsl:param name="output-folder">/tmp/cityehr-modular</xsl:param>
  
  <xsl:template match="topic">
    <!-- Generate an LwDITA Map -->
    <xsl:result-document href="{$output-folder}/quickstart-guide.ditamap" omit-xml-declaration="no" indent="yes" doctype-public="-//OASIS//DTD LIGHTWEIGHT DITA Map//EN" doctype-system="map.dtd">
      <map id="{@id}">
        <topicmeta>
          <navtitle><xsl:value-of select="title"/></navtitle>
        </topicmeta>
        <xsl:for-each select="body/section">
          <topicref href="{@id}.dita"/>
        </xsl:for-each>
      </map>
    </xsl:result-document>
    <!-- Move on to later generating the LwDITA Topics from the sections -->
    <xsl:apply-templates select="body"/>
  </xsl:template>
  
  <xsl:template match="body">
    <xsl:apply-templates select="section"/>
  </xsl:template>
  
  <xsl:template match="section">
    <!-- Generate an LwDITA Topic from the section -->
    <xsl:result-document href="{concat($output-folder, '/', @id, '.dita')}">
      <topic>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="title"/>
        <body>
          <xsl:apply-templates select="node()[local-name(.) ne 'title']|@*"/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>