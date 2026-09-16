<?xml version="1.0" encoding="UTF-8"?>
<!--
  War-overlay override to add Google Analytics 4 tracking
  Extends the core-geonetwork render-html.xsl
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:include href="../base-layout-cssjs-loader.xsl"/>

  <xsl:template name="render-html">
    <xsl:param name="content"/>
    <xsl:param name="title"
               select="/root/gui/systemConfig/settings/system/site/name"/>
    <xsl:param name="description"
               select="/root/gui/systemConfig/settings/strings/mainpage2"/>
    <xsl:param name="thumbnail"
               select="concat(/root/gui/url,'/images/logos/favicon.png')"/>
    <xsl:param name="type"
               select="'dataset'"/>
    <xsl:param name="meta" required="no" as="node()*"/>

    <html ng-app="{$angularModule}" lang="{$lang2chars}" id="ng-app">
      <head>
        <title><xsl:value-of select="if($title != '')
                  then $title
                  else /root/gui/systemConfig/settings/system/site/name"/></title>
        <base href="{$nodeUrl}eng/catalog.search"/>
        <meta charset="utf-8"/>

        <xsl:copy-of select="$meta"/>

        <meta name="viewport" content="initial-scale=1.0"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>

        <meta name="description" content="{normalize-space($description)}"/>
        <meta name="keywords" content=""/>

        <meta property="og:title" content="{$title}" />
        <meta property="og:description" content="{normalize-space($description)}" />
        <meta property="og:site_name" content="{/root/gui/systemConfig/settings/system/site/name}" />
        <meta property="og:image" content="{$thumbnail}" />

        <meta name="twitter:card" content="summary" />
        <meta name="twitter:image" content="{$thumbnail}" />
        <meta name="twitter:title" content="{$title}" />
        <meta name="twitter:description" content="{normalize-space($description)}" />
        <meta name="twitter:site" content="{/root/gui/systemConfig/settings/system/site/name}" />

        <xsl:if test="/root/info/record/uuid">
          <link rel="canonical" href="{$nodeUrl}api/records/{/root/info/record/uuid}" />
        </xsl:if>
        <link rel="icon" sizes="16x16 32x32 48x48" type="image/png"
              href="{/root/gui/url}/images/logos/favicon.png"/>
        <link href="{$nodeUrl}eng/rss.search?sortBy=changeDate"
              rel="alternate"
              type="application/rss+xml"
              title="{$title}"/>
        <link href="{$nodeUrl}eng/portal.opensearch"
              rel="search"
              type="application/opensearchdescription+xml"
              title="{$title}"/>

        <xsl:call-template name="css-load-nojs"/>
        <!-- Google Analytics 4 -->
        <xsl:call-template name="ga4-load-head"/>
      </head>

      <body class="gn-nojs {$cssClass}">
        <div class="gn-full">
          <xsl:call-template name="header"/>
          <div class="container" role="main">
            <xsl:copy-of select="$content"/>
          </div>
          <xsl:call-template name="footer"/>
          <!-- Google Analytics 4 -->
          <xsl:call-template name="ga4-load-body"/>
        </div>

        <xsl:call-template name="webAnalytics"/>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
