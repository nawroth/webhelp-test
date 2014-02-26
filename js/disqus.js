function initDisqus()
{
  var OPEN_ICON = 'fa-minus-circle';
  var CLOSED_ICON = 'fa-plus-circle';
  var $pageContent = $( '#content' );
  var $wrapper = $( '<div id="discuss" />' );
  var $header = $( '<div id="discuss-header"><i id="discuss-icon" class="fa fa-comments"></i> <b>Comments</b></div>' );
  var $toggle = $( '<i id="discuss-toggle" class="fa ' + CLOSED_ICON + '"></i>' );
  var $body = $( '<div id="discuss-body" />' );
  var $thread = $( '<div id="disqus_thread"></div>' );
  $header.append( $toggle );
  $wrapper.append( $header );
  $body.append( $thread );
  $wrapper.append( $body );

  var initialized = false;
  var isOpen = false;

  $header.click( function()
  {
    if ( isOpen )
    {
      $body.css( 'display', 'none' );
      $toggle.removeClass( OPEN_ICON ).addClass( CLOSED_ICON );
    }
    else
    {
      if ( !initialized )
      {
        initialized = true;
        runDisqus( $thread );
      }
      $body.css( 'display', 'block' );
      $toggle.removeClass( CLOSED_ICON ).addClass( OPEN_ICON );
      $pageContent.animate( {
        scrollTop : ( $pageContent.scrollTop() + $wrapper.offset().top )
      }, 500 );
    }
    isOpen = !isOpen;
  } );

  $( '#content > footer' ).first().prepend( $wrapper );
}

$( document ).ready( initDisqus );

function runDisqus( $thread )
{
  window.disqus_identifier = "manual";
  window.disqus_title = "The Neo4j Manual";

  function getIdFromHeading( headingElement )
  {
    var id = window.disqus_identifier;
    var child = headingElement.firstChild;
    if ( !child || child.nodeName.toLowerCase() !== "a" )
    {
      return null;
    }
    var attr = child.getAttribute( "id" );
    if ( !attr )
    {
      return null;
    }
    id += "-";
    id += headingElement.firstChild.getAttribute( "id" );
    return id;
  }
  var headings = document.body.getElementsByTagName( "h1" );
  if ( headings.length > 0 )
  {
    var h1Id = getIdFromHeading( headings[0] );
    if ( h1Id )
    {
      if ( h1Id.length > 2 && h1Id.substr( 0, 9 ) === "manual-id" )
      {
        window.disqus_identifier += "-toc";
      }
      else
      {
        window.disqus_identifier = h1Id;
      }
    }
  }
  else
  {
    headings = document.body.getElementsByTagName( "h2" );
    if ( headings.length > 0 )
    {
      var id = getIdFromHeading( headings[0] );
      if ( id )
      {
        window.disqus_identifier = id;
      }
      else
      {
        var divs = document.body.getElementsByTagName( "div" );
        for ( var i = 0, l = divs.length; i < l; i += 1 )
        {
          var div = divs[i];
          if ( div.className === "refsynopsisdiv" )
          {
            var divId = getIdFromHeading( div );
            if ( divId )
            {
              window.disqus_identifier = divId;
            }
            break;
          }
        }
      }
    }
    if ( document.title )
    {
      window.disqus_title = document.title;
      var match = window.disqus_title.match( /^(Chapter|)[0-9\.\s]*(.*)$/ );
      if ( match && match[2] )
      {
        window.disqus_title = match[2];
      }
    }
  }

  window.disqus_url = window.location;
  window.disqus_shortname = "neo4j";
  if ( window.disqus_url.host.indexOf( 'neo4j.' ) !== -1 && window.disqus_url.pathname.indexOf( '/lab/' ) === -1 )
  {
    var docsLocation = "http://docs.neo4j.org/chunked/snapshot/";
    var path = window.disqus_url.pathname;
    var position = path.lastIndexOf( '/' );
    if ( position === -1 )
    {
      position = path.lastIndexOf( '\\' );
    }
    if ( position > 0 )
    {
      var page = path.substring( position + 1 );
      window.disqus_url = docsLocation + page;
    }
  }
  else
  {
    window.disqus_shortname = 'neo4j-manual-staging';
  }

  var $intro = $( '<div id="discuss-intro"/>' );
  var listWrapper = $( '<div class="itemizedlist">' );
  var list = $( '<ul type="disc" class="itemizedlist" />' );
  listWrapper.append( list );
  $intro.append( listWrapper );

  function appendListItem( list, heading, content )
  {
    list.append( "<li class='listitem'><em>" + heading + "</em> " + content + "</li>" );
  }

  appendListItem( list, "Having trouble running an example from the manual?",
      "First make sure that you're using the same version of Neo4j as the manual was built for! "
          + "Choose version at the top of the page." );
  appendListItem( list, "Something doesn't work?",
      "Use the stackoverflow.com <a href='http://stackoverflow.com/questions/tagged/neo4j'>neo4j tag</a>!" );
  appendListItem( list, "Found a bug?",
      "GitHub <a href='https://github.com/neo4j/neo4j/issues'>Neo4j Issues</a> is for you. "
          + "For <i>documentation bugs</i>, use the Disqus thread below." );
  appendListItem(
      list,
      "Have a data modeling question or want to participate in discussions around Neo4j and graphs?",
      "The <a href='https://groups.google.com/forum/?fromgroups#!forum/neo4j'>Neo4j Google Group</a> is a great place for this." );
  appendListItem( list, "Is 140 characters enough?",
      "Go <a href='https://twitter.com/search?q=neo4j'>#neo4j</a>." );
  appendListItem( list, "Have a question on the content of this page or missing something here?",
      "Use the discussion thread below. "
          + "Please post any comments or suggestions regarding the documentation right here!" );

  $thread.before( $intro );

  ( function()
  {
    var dsq = document.createElement( 'script' );
    dsq.type = 'text/javascript';
    dsq.async = true;
    dsq.src = 'http://' + window.disqus_shortname + '.disqus.com/embed.js';
    ( document.getElementsByTagName( 'head' )[0] || document.getElementsByTagName( 'body' )[0] ).appendChild( dsq );
  } )();
}
