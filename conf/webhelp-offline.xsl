<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:d="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="urn:docbkx:stylesheet" />

  <xsl:template match="d:formalpara[@role = 'cypherconsole']" />
  <xsl:template match="d:simpara[@role = 'cypherconsole']" />

  <!-- Get rid of table numbering -->
  <xsl:param name="local.l10n.xml" select="document('')" />
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="en">
      <l:context name="title">
        <l:template name="table" text="%t" />
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="table" text="%t" />
      </l:context>
    </l:l10n>
  </l:i18n>

  <xsl:template name="webhelpheader.logo">
    <a href="index.html">
      <img style='margin-right: 2px; height: 49px; padding-right: 25px; padding-top: 8px' align="right"
        src='images/neo4j-logo.png' alt="" />
    </a>
  </xsl:template>

  <xsl:template name="user.footer.navigation">
    <xsl:if test="@id = 'preface'">
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename">
          <xsl:value-of select="concat($webhelp.base.dir,'/webhelp-tree.html')" />
        </xsl:with-param>
        <xsl:with-param name="method" select="'html'" />
        <xsl:with-param name="omit-xml-declaration" select="'yes'" />
        <xsl:with-param name="encoding" select="'utf-8'" />
        <xsl:with-param name="indent" select="'no'" />
        <xsl:with-param name="doctype-public" select="''" />
        <xsl:with-param name="doctype-system" select="''" />
        <xsl:with-param name="content">
          <xsl:call-template name="webhelptoc">
            <xsl:with-param name="currentid" select="generate-id(.)" />
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Included to get rid of the webhelp-currentid getting set on an element. -->
  <!-- Generates the webhelp table-of-contents (TOC). -->
  <xsl:template
    match="d:book|d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv|d:index|d:setindex"
    mode="webhelptoc">
    <xsl:param name="currentid" />
    <xsl:variable name="title">
      <xsl:if test="$webhelp.autolabel=1">
        <xsl:variable name="label.markup">
          <xsl:apply-templates select="." mode="label.markup" />
        </xsl:variable>
        <xsl:if test="normalize-space($label.markup)">
          <xsl:value-of select="concat($label.markup,$autotoc.label.separator)" />
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="." mode="titleabbrev.markup" />
    </xsl:variable>

    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="$manifest.in.base.dir != 0">
          <xsl:call-template name="href.target" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="href.target.with.base.dir" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="id" select="generate-id(.)" />

    <xsl:if test="not(self::d:index) or (self::d:index and not($generate.index = 0))">
      <!--li style="white-space: pre; line-height: 0em;" -->
      <li>
        <span class="file">
          <a href="{substring-after($href, $base.dir)}" tabindex="1">
            <xsl:value-of select="$title" />
          </a>
        </span>
        <xsl:if
          test="d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv">
          <ul>
            <xsl:apply-templates
              select="d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv"
              mode="webhelptoc">
              <xsl:with-param name="currentid" select="$currentid" />
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <!-- <xsl:import href="common.xsl"/> <xsl:import href="html-params.xsl"/> <xsl:import href="head-offline.xsl"/> 
    <xsl:import href="syntaxhighlight.xsl"/> <xsl:import href="offline-footer.xsl"/> -->

</xsl:stylesheet>

