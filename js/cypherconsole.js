/**
 * Licensed to Neo Technology under one or more contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership. Neo Technology licenses this file to you under
 * the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You
 * may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

/*
 * Cypher Console Adds live cypher console feature to a page.
 */

jQuery( document ).ready( function()
{
  createCypherConsoles( jQuery );
} );

function createCypherConsoles( $ )
{
  var URL_BASE = "http://console.neo4j.org/";
  var REQUEST_BASE = URL_BASE + "?";
  var currentButton;
  var tocWasOpen;
  var $cypherdocConsole;

  $( 'pre[data-lang="cypher"]' ).wrap( '<div class="query-outer-wrapper"><div class="query-wrapper" /></div>' ).each(
      function()
      {
        var $pre = $( this );
        $pre.parent().data( 'query', $pre.text() );
      } );

  $( 'p.cypherconsole' )
      .each(
          function()
          {
            var $context = $( this );
            var title = $.trim( $context.children( 'span.formalpara-title' ).eq( 0 ).text() );
            if ( !title )
            {
              title = $.trim( $context.find( '> b, > strong' ).eq( 0 ).text() ) || 'Live Cypher Console';
            }
            title = title.replace( /\.$/, '' );
            var database = $.trim( $context.children( 'span.database' ).eq( 0 ).text() );
            if ( !database )
              return;
            var command = $.trim( $context.children( 'span.command' ).children( 'strong' ).eq( 0 ).text() );
            if ( !command )
              return;
            var button = $( '<a href="javascript:;" class="btn btn-primary" title="' + title
                + '"><i class="fa fa-play"></i></a>' );
            var url = getUrl( database, command );
            var link = $( '<a href="'
                + url
                + '" class="btn btn-default" target="_blank" title="Open the console in a new window."><i class="fa fa-external-link"></i><span>&#8201;</span></a>' );
            var $queryOuterWrapper = $context.prevAll( 'div.query-outer-wrapper' ).first();
            $queryOuterWrapper.children( 'div.query-wrapper' ).css( "margin-left", "32px" );
            var buttonWrapper = $( '<div class="btn-group btn-group-xs btn-group-vertical"/>' ).appendTo(
                $queryOuterWrapper ).append( button, link );
            button.click( function()
            {
              handleCypherClick( buttonWrapper, link, url, title );
            } );
          } );

  $( 'p.cypherdoc-console' ).first().each( function()
  {
    $cypherdocConsole = $( this ).css( 'display', 'block' );
    CypherConsole( {
      'url' : URL_BASE,
      'consoleClass' : 'cypherdoc-console',
      'contentMoveSelector' : '#content',
      'expandHeightCorrection' : 95,
      'onExpand' : onExpand,
      'onUnexpand' : onUnexpand
    } );
  } );

  function onExpand()
  {
    tocWasOpen = !window.webhelpLayout.state.west.isClosed;
    window.webhelpLayout.hide( 'west' );
    $cypherdocConsole.css( 'display', 'inline' );
  }

  function onUnexpand()
  {
    window.webhelpLayout.show( 'west', tocWasOpen );
    $cypherdocConsole.css( 'display', 'block' );
  }

  function getUrl( database, command, message )
  {
    var url = REQUEST_BASE;
    if ( database !== undefined )
    {
      url += "init=" + encodeURIComponent( database );
    }
    if ( command !== undefined )
    {
      url += "&query=" + encodeURIComponent( command );
    }
    if ( message !== undefined )
    {
      url += "&message=" + encodeURIComponent( message );
    }
    if ( window.neo4jVersion != undefined )
    {
      url += "&version=" + encodeURIComponent( neo4jVersion );
    }
    return url + "&no_root=true";
  }

  function handleCypherClick( button, link, url, title )
  {
    var iframe = $( "#console" );
    if ( iframe.length )
    {
      iframe.remove();
    }
    if ( button === currentButton )
    {
      // hitting the same button again -- don't add a new console
      currentButton = null;
      return;
    }
    iframe = $( "<iframe/>" ).attr( "id", "console" ).addClass( "console" ).attr( "src", url );
    button.before( iframe );
    currentButton = button;
  }
}
