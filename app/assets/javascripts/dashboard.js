jQuery(document).ready(function($) {

  if ( !!$('body.dashboard').length ) {

    // Sortables
    $( "#office, #feeds" ).sortable({
      axis: 'y',
      handle: 'h3'
    });
    $( ".column-3" ).sortable({
      axis: 'y',
      handle: 'h2'
    });

    $( ".box" ).addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
      .find( ".box h3" )
        .addClass( "ui-widget-header ui-corner-all" )
        .prepend( "<span class='ui-icon ui-icon-minusthick'></span>");

    $( ".box h3 .ui-icon" ).click(function() {
      $( this ).toggleClass( "ui-icon-minusthick" ).toggleClass( "ui-icon-plusthick" );
      $( this ).parents( ".box:first" ).find( ".box-content" ).toggle();
    });
  }
});
