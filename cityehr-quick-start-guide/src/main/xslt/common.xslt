<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:com="http://cityehr/common"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!--
    Common code for processing an LwDITA 'topic' or 'map'.
    
    Author: Adam Retter
  -->
  
  <!--
    Creates a comman and (finally) 'and' separated list, includes an Oxford comma before the 'and'.
    e.g. ('a', 'b', 'c') => 'a, b, and c'
  -->
  <xsl:function name="com:format-inline-text-list" as="xs:string?">
    <xsl:param name="items" as="xs:string*" required="yes"/>
    <xsl:sequence select="replace(string-join($items, ', '), '^(.+,)\s([^,]+)$', '$1 and $2')"/>
  </xsl:function>
  
  <!--
    Finds the URI of the document from which a node originated.
  -->
  <xsl:function name="com:document-uri" as="xs:string">
    <xsl:param name="node" as="node()" required="yes"/>
    <xsl:sequence select="document-uri(root($node))"/>
  </xsl:function>
  
  <!--
   Given a file path, return the parent path (e.g. folder path).
  -->
  <xsl:function name="com:parent-path" as="xs:string">
    <xsl:param name="uri" as="xs:string" required="yes"/>
    <xsl:sequence select="replace($uri, '(.+)/.+', '$1')"/>
  </xsl:function>
  
  <!--
   Given a file path, return just the filename.
  -->
  <xsl:function name="com:filename" as="xs:string">
    <xsl:param name="uri" as="xs:string" required="yes"/>
    <xsl:sequence select="replace($uri, '.+/(.+)', '$1')"/>
  </xsl:function>

  <!--
   Given a node as context and a reletaive HREF, create an absolute URI.
  -->
  <xsl:function name="com:abs-uri" as="xs:string">
    <xsl:param name="context" as="node()" required="yes"/>
    <xsl:param name="rel-href" as="xs:string" required="yes"/>
    <xsl:sequence select="concat(com:parent-path(com:document-uri($context)), '/', $rel-href)"/>
  </xsl:function>
  
  <!-- Get the title of a topic by loading the topic from a topicref -->
  <xsl:function name="com:get-topic-title" as="xs:string">
    <xsl:param name="context" as="node()" required="yes"/>
    <xsl:param name="topicref" as="element(topicref)" required="yes"/>
    <xsl:sequence select="doc(com:abs-uri($context, $topicref/@href))/topic/title"/>
  </xsl:function>

</xsl:stylesheet>