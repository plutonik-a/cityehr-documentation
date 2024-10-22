<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:file="http://expath.org/ns/file"
  exclude-result-prefixes="xs"
  version="2.0">

  <!--
    Extracts embedded images from an LwDITA 'topic'
    into individual image files.

    Author: Adam Retter
  -->

  <xsl:output indent="no"/>
  
  <!-- PARAMETER - the path to the folder where you want to output the image files -->
<!--  <xsl:param name="output-folder">/tmp/cityehr-modular/images</xsl:param>-->
  <xsl:param name="output-folder">/Users/jenniferramirez/Desktop/John Chelsom/QuickstartGuide/Images</xsl:param>  
  
  <xsl:template match="image[starts-with(@href, 'data:image/')]">
    <xsl:variable name="media-type" select="substring-before(substring-after(@href, 'data:'), ';')"/>
    <xsl:variable name="filename" select="concat(substring-before(substring-after(@href, 'id='), ';'), '.', substring-after($media-type, '/'))"/>
    <xsl:variable name="content" select="substring-after(@href, ';base64,')"/>
    
    <!-- Write the image file to disk --> 
    <xsl:sequence select="file:write-binary(concat($output-folder, '/', $filename), xs:base64Binary($content))"/>
    
    <!-- copy and adjust the 'image' element to point at the new file -->
    <xsl:copy>
      <xsl:attribute name="href" select="concat('images/', $filename)"/>
      <xsl:attribute name="format" select="$media-type"/>
      <!-- process any child elements of the 'image' element --> 
      <xsl:apply-templates select="child::element()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>