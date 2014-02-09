<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="d">

<xsl:template name="user.webhelp.head.content">
<xsl:text disable-output-escaping="yes">
<![CDATA[

<!-- favicon -->

<link rel="shortcut icon" href="http://neo4j.org/favicon.ico" type="image/vnd.microsoft.icon" />
<link rel="icon" href="http://neo4j.org/favicon.ico" type="image/x-icon" />

<!-- fonts -->

<link href='http://fonts.googleapis.com/css?family=Ubuntu+Mono|PT+Sans:400,700,400italic' rel='stylesheet' type='text/css' />

<!-- Syntax Highlighter -->

<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.min.css" />
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/addon/runmode/runmode.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/javascript/javascript.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/shell/shell.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/sql/sql.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/clike/clike.min.js"></script>

<link rel="stylesheet" href="css/codemirror-neo.css" />
<script src="js/codemirror-cypher.js"></script>
<script src="js/colorize.js"></script>
 
<script type="text/javascript">
  $(function (){
    CodeMirror.colorize();
  });
</script>

<!-- Image Scaler -->
<script type="text/javascript" src="js/imagescaler.js"></script>

<!-- Cypher Console -->

<script type="text/javascript" src="js/console.js"></script>
<script type="text/javascript" src="js/cypherconsole.js"></script>
 
<!-- Version
<script type="text/javascript" src="js/version.js"></script>
 -->

]]>
</xsl:text>

</xsl:template>

</xsl:stylesheet>

