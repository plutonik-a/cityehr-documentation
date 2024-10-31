<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:htop="http://cityehr/html/topic"
  xmlns:hcom="http://cityehr/html/common"
  xmlns:com="http://cityehr/common"
  exclude-result-prefixes="xs hcom ditaarch"
  version="2.0">
  
  <!--
    Generates a simple HTML page from an LwDITA 'topic'.
    Author: Adam Retter
  -->

  <xsl:import href="common.xslt"/>
  <xsl:import href="common-html.xslt"/>

  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="petal-api-url" />
  <xsl:param name="petal-github-org-name" />
  <xsl:param name="petal-github-repo-name" />
  <xsl:param name="petal-github-branch" />
  <xsl:param name="petal-referrer-base-url" />

  <xsl:variable name="authors" as="xs:string+" select="('John Chelsom', 'Stephanie Cabrera', 'Catriona Hopper', 'Jennifer Ramirez')"/>
  
  <xsl:template match="topic">
    <html>
      <head>
        <xsl:call-template name="hcom:meta">
          <xsl:with-param name="authors" select="$authors"/>
        </xsl:call-template>
      </head>
      <body>
        <nav id="top-nav">
          <xsl:apply-templates select="." mode="top-nav"/>
        </nav>

        <!-- Petal Edit Button -->
        <div id="petal-edit-page-button">
          <a href="{htop:petal-edit-url(.)}">
            <input type="button" value="Edit this page"/>
          </a>
        </div>

        <article>
          <xsl:apply-templates select="element()" mode="body"/>
        </article>
        <nav id="bottom-nav">
          <xsl:apply-templates select="." mode="bottom-nav"/>
        </nav>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="topic" mode="top-nav bottom-nav">
    <div id="contents-link"><a href="index.html">Return to Contents...</a></div>
  </xsl:template>

  <xsl:template match="title" mode="metadata">
    <title><xsl:value-of select="."/></title>
  </xsl:template>
  
  <xsl:template match="title" mode="body">
    <h1><xsl:value-of select="."/></h1>
  </xsl:template>
  
  <xsl:template match="p|b|i|ol|ul|li" mode="body">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates mode="body"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="image" mode="body">
    <figure>
      <img src="{@href}">
      <xsl:attribute name="width" select="960"/>
      </img>
    </figure>
  </xsl:template>

  <xsl:template match="image[alt]" mode="body">
    <figure>
      <img src="{@href}">
        <xsl:if test="alt">
          <xsl:attribute name="alt" select="alt"/>
        </xsl:if>
      </img>
      <figcaption><xsl:value-of select="alt"/></figcaption>
    </figure>
  </xsl:template>

  <xsl:template match="image[empty(alt)]" mode="body">
    <img src="{@href}">
      <xsl:if test="alt">
        <xsl:attribute name="alt" select="alt"/>
      </xsl:if>
    </img>
  </xsl:template>

  <xsl:template match="xref" mode="body">
    <a href="{@href}">
      <xsl:apply-templates mode="body"/>
    </a>
  </xsl:template>

  <xsl:template match="section" mode="body">
    <section>
      <xsl:apply-templates select="title|p|b|i|ol|ul|li|image|section" mode="body"/>
    </section>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::body]" mode="body">
    <h2><xsl:value-of select="."/></h2>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::body]" mode="body">
    <h3><xsl:value-of select="."/></h3>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::section/parent::body]" mode="body">
    <h4><xsl:value-of select="."/></h4>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::section/parent::section/parent::body]" mode="body">
    <h5><xsl:value-of select="."/></h5>
  </xsl:template>

  <xsl:template match="title[parent::section/parent::section/parent::section/parent::section/parent::section/parent::body]" mode="body">
    <h6><xsl:value-of select="."/></h6>
  </xsl:template>

  <!--
    Generates an Edit button URL for Petal
  -->
  <xsl:function name="htop:petal-edit-url" as="xs:string">
    <xsl:param name="topic" as="element(topic)" required="yes"/>
    <xsl:variable name="petal-source-file-uri" select="com:document-uri($topic)" />
    <xsl:variable name="petal-source-file" select="substring-after($petal-source-file-uri, concat($petal-github-repo-name, '/'))" />
    <xsl:variable name="petal-webpage-filename" select="hcom:dita-filename-to-html(com:filename($petal-source-file-uri))" />
    <xsl:sequence select="concat($petal-api-url, '?ghrepo=', $petal-github-org-name, '/', $petal-github-repo-name, '&amp;source=', $petal-source-file, '&amp;branch=', $petal-github-branch, '&amp;referer=', $petal-referrer-base-url, '/', $petal-webpage-filename)" />
  </xsl:function>

</xsl:stylesheet>