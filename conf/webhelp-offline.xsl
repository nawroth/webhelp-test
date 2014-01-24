<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:d="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="urn:docbkx:stylesheet" />

  <xsl:import href="common.xsl"/>
  <xsl:import href="html-params.xsl"/>
  
  <!--   <xsl:import href="head-offline.xsl"/> 
    <xsl:import href="syntaxhighlight.xsl"/> <xsl:import href="offline-footer.xsl"/> -->

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
        <xsl:with-param name="method" select="'xml'" />
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
    <xsl:param name="level" select="0" />
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
          test="$level &lt; 2 and (d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv)">
          <ul>
            <xsl:apply-templates
              select="d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv"
              mode="webhelptoc">
              <xsl:with-param name="currentid" select="$currentid" />
              <xsl:with-param name="level" select="$level + 1" />
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <!-- Included to remove event handler in html on the sidebar toggle button. -->
  <!-- The Header with the company logo -->
  <xsl:template name="webhelpheader">
    <xsl:param name="prev" />
    <xsl:param name="next" />
    <xsl:param name="nav.context" />

    <xsl:variable name="home" select="/*[1]" />
    <xsl:variable name="up" select="parent::*" />

    <div id="header">
      <xsl:call-template name="webhelpheader.logo" />
      <!-- Display the page title and the main heading(parent) of it -->
      <h1>
        <xsl:apply-templates select="/*[1]" mode="title.markup" />
        <br />
        <xsl:choose>
          <xsl:when test="count($up) &gt; 0 and generate-id($up) != generate-id($home)">
            <xsl:apply-templates select="$up" mode="object.title.markup" />
          </xsl:when>
          <xsl:when test="not(generate-id(.) = generate-id(/*))">
            <xsl:apply-templates select="." mode="object.title.markup" />
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </h1>
      <!-- Prev and Next links generation -->
      <div id="navheader">
        <xsl:call-template name="user.webhelp.navheader.content" />
        <xsl:comment>
          <!-- KEEP this code. In case of neither prev nor next links are available, this will help to 
            keep the integrity of the DOM tree -->
        </xsl:comment>
        <!--xsl:with-param name="prev" select="$prev"/> <xsl:with-param name="next" select="$next"/> 
          <xsl:with-param name="nav.context" select="$nav.context"/ -->
        <table class="navLinks">
          <tr>
            <td>
              <a id="showHideButton" href="#" class="pointLeft" tabindex="5" title="Show/Hide TOC tree">Sidebar
              </a>
            </td>
            <xsl:if
              test="count($prev) &gt; 0
                            or (count($up) &gt; 0
                            and generate-id($up) != generate-id($home)
                            and $navig.showtitles != 0)
                            or count($next) &gt; 0">
              <td>
                <xsl:if test="count($prev)>0">
                  <a accesskey="p" class="navLinkPrevious" tabindex="5">
                    <xsl:attribute name="href">
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object"
                      select="$prev" />
                                            </xsl:call-template>
                                        </xsl:attribute>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'prev'" />
                    </xsl:call-template>
                  </a>
                </xsl:if>

                <!-- "Up" link -->
                <xsl:choose>
                  <xsl:when
                    test="count($up)&gt;0
                                              and generate-id($up) != generate-id($home)">
                    |
                    <a accesskey="u" class="navLinkUp" tabindex="5">
                      <xsl:attribute name="href">
                                                <xsl:call-template name="href.target">
                                                    <xsl:with-param name="object"
                        select="$up" />
                                                </xsl:call-template>
                                            </xsl:attribute>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'up'" />
                      </xsl:call-template>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    &#160;
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="count($next)>0">
                  |
                  <a accesskey="n" class="navLinkNext" tabindex="5">
                    <xsl:attribute name="href">
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object"
                      select="$next" />
                                            </xsl:call-template>
                                        </xsl:attribute>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'next'" />
                    </xsl:call-template>
                  </a>
                </xsl:if>
              </td>
            </xsl:if>
          </tr>
        </table>
      </div>
    </div>
  </xsl:template>

  <!-- Included to get rid of splitterInit.js - we have moved that code to main.js.
  and main.js is now loaded from elsewhere. -->
  <xsl:template name="user.footer.content"/>

  <!-- Included to load main.js as early as possible and to set
   display:block on the sidebar, which now loaded dynamically.
   Also sets a fixed width on leftnavigation to fit in the sidebar.
   And makes webhelp-currentid a dynamicallly injected class, not an id.-->
  <xsl:template name="system.head.content">
    <xsl:param name="node" select="." />
    <xsl:text>
    </xsl:text>
    <!-- The meta tag tells the IE rendering engine that it should use the latest, or edge, version of 
      the IE rendering environment;It prevents IE from entring compatibility mode. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <xsl:text>
    </xsl:text>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <xsl:text>
    </xsl:text>
  </xsl:template>

  <!-- HTML <head> section customizations -->
  <xsl:template name="user.head.content">
    <xsl:param name="title">
      <xsl:apply-templates select="." mode="object.title.markup.textonly" />
    </xsl:param>
    <meta name="Section-title" content="{$title}" />

    <!-- <xsl:message> webhelp.tree.cookie.id = <xsl:value-of select="$webhelp.tree.cookie.id"/> +++ 
      <xsl:value-of select="count(//node())"/> $webhelp.indexer.language = <xsl:value-of select="$webhelp.indexer.language"/> 
      +++ <xsl:value-of select="count(//node())"/> </xsl:message> -->
    <script type="text/javascript">
      //The id for tree cookie
      var treeCookieId = "<xsl:value-of select="$webhelp.tree.cookie.id"/>";
      var language = "<xsl:value-of select="$webhelp.indexer.language"/>";
      var w = new Object();
      //Localization
      txt_filesfound = '<xsl:call-template name="gentext.template">
        <xsl:with-param name="name" select="'txt_filesfound'" />
        <xsl:with-param name="context" select="'webhelp'" />
      </xsl:call-template>';
      txt_enter_at_least_1_char = "<xsl:call-template name="gentext.template">
        <xsl:with-param name="name" select="'txt_enter_at_least_1_char'" />
        <xsl:with-param name="context" select="'webhelp'" />
      </xsl:call-template>";
      txt_browser_not_supported = "<xsl:call-template name="gentext.template">
        <xsl:with-param name="name" select="'txt_browser_not_supported'" />
        <xsl:with-param name="context" select="'webhelp'" />
      </xsl:call-template>";
      txt_please_wait = "<xsl:call-template name="gentext.template">
        <xsl:with-param name="name" select="'txt_please_wait'" />
        <xsl:with-param name="context" select="'webhelp'" />
      </xsl:call-template>";
      txt_results_for = "<xsl:call-template name="gentext.template">
        <xsl:with-param name="name" select="'txt_results_for'" />
        <xsl:with-param name="context" select="'webhelp'" />
      </xsl:call-template>";
    </script>

    <!-- kasunbg: Order is important between the in-html-file css and the linked css files. Some css 
      declarations in jquery-ui-1.8.2.custom.css are over-ridden. If that's a concern, just remove the additional 
      css contents inside these default jquery css files. I thought of keeping them intact for easier maintenance! -->
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="{$webhelp.common.dir}css/positioning.css" />
    <!-- upgraded from jquery-ui-1.8.2.custom.css -->
    <link rel="stylesheet" type="text/css"
      href="{$webhelp.common.dir}jquery/theme-redmond/jquery-ui-1.10.4.custom.min.css" />
    <link rel="stylesheet" type="text/css" href="{$webhelp.common.dir}jquery/treeview/jquery.treeview.css" />

    <link rel="stylesheet" type="text/css" href="{$webhelp.common.dir}style.css" />
    <xsl:comment>
      <xsl:text>[if IE]>
  &lt;link rel="stylesheet" type="text/css" href="../common/css/ie.css"/>
  &lt;![endif]</xsl:text>
    </xsl:comment>

    <!-- browserDetect is an Oxygen addition to warn the user if they're using chrome from the file system. 
      This breaks the Oxygen search highlighting. -->
    <script type="text/javascript" src="{$webhelp.common.dir}browserDetect.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <!-- upgraded from 1.7.2 -->
    <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery-1.10.2.min.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <!-- upgraded from "jquery.ui.all.js" -->
    <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery-ui-1.10.4.custom.min.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <!-- moved highlight to a separate file (previously together with jquery-ui) -->
    <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery.highlight.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery.cookie.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <script type="text/javascript" src="{$webhelp.common.dir}jquery/treeview/jquery.treeview.min.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <!-- use a more recent, minifed, version -->
    <script type="text/javascript" src="{$webhelp.common.dir}jquery/layout/jquery.layout.min.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <script type="text/javascript" src="{$webhelp.common.dir}main.js">
      <xsl:comment>
      </xsl:comment>
    </script>
    <xsl:if test="$webhelp.include.search.tab != '0'">
      <!--Scripts/css stylesheets for Search -->
      <!-- TODO: Why THREE files? There's absolutely no need for having separate files. These should 
        have been identified at the optimization phase! -->
      <script type="text/javascript" src="search/l10n.js">
        <xsl:comment />
      </script>
      <script type="text/javascript" src="search/htmlFileInfoList.js">
        <xsl:comment>
        </xsl:comment>
      </script>
      <script type="text/javascript" src="search/nwSearchFnt.js">
        <xsl:comment>
        </xsl:comment>
      </script>

      <!-- NOTE: Stemmer javascript files should be in format <language>_stemmer.js. For example, for 
        English(en), source should be: "search/stemmers/en_stemmer.js" For country codes, see: http://www.uspto.gov/patft/help/helpctry.htm -->
      <!--<xsl:message><xsl:value-of select="concat('search/stemmers/',$webhelp.indexer.language,'_stemmer.js')"/></xsl:message> -->
      <script type="text/javascript" src="{concat('search/stemmers/',$webhelp.indexer.language,'_stemmer.js')}">
        <xsl:comment>
          //make this scalable to other languages as well.
        </xsl:comment>
      </script>

      <!--Index Files: Index is broken in to three equal sized(number of index items) files. This is 
        to help parallel downloading of files to make it faster. TODO: Generate webhelp index for largest docbook 
        document that can be find, and analyze the file sizes. IF the file size is still around ~50KB for a given 
        file, we should consider merging these files together. again. -->
      <script type="text/javascript" src="search/index-1.js">
        <xsl:comment>
        </xsl:comment>
      </script>
      <script type="text/javascript" src="search/index-2.js">
        <xsl:comment>
        </xsl:comment>
      </script>
      <script type="text/javascript" src="search/index-3.js">
        <xsl:comment>
        </xsl:comment>
      </script>
      <!--End of index files -->
    </xsl:if>
    <xsl:call-template name="user.webhelp.head.content" />
  </xsl:template>

</xsl:stylesheet>

