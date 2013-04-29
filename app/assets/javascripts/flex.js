jQuery(document).ready(function($) {

  // Flex simulation
  var $flex = $( '#flex' );

  if ( $flex.length ) {

    $flex.find( "p.controls span" ).click( function() {

      var $this = $(this);
      $flex.addClass('loading');
      $flex.find( "p.action" ).html("Flexar &hellip;" );
      $flex.find( "div.status" ).removeClass('success warning error active');
      $flex.find( "p.sum" ).hide();

      setTimeout(function() {
        $flex.removeClass('loading');

        var warning = Math.floor( Math.random() * 4) === 3 ? true : false;
        var error = Math.floor( Math.random() * 8) === 3 ? true : false;

        var response;
        if (error) {
          response = 'HRutan gick inte att nå!<br/>Vänligen försök lite senare.';
          $flex.find( "div.status" ).addClass('error');
          $flex.find( "p.sum" ).text("Flexsaldo: +5,5 timmar.");
        } else {
          switch ($this.attr('data-action')) {
            case 'in':
              response = warning ? 'Nu blev det fel!<br/> Du är redan inflexad.' : 'Nu har du flexat in.';
              break;
            case 'break-out':
              response = warning ?  'Nu blev det fel!<br/> Du är redan utrastad.' : "Nu har du rastat ut.";
              break;
            case 'break-in':
              response = warning ? 'Nu blev det fel!<br/> Du är redan inrastad.' : 'Nu har du rastat in.';
              break;
            case 'out':
              response = warning ? 'Nu blev det fel!<br/> Du är redan utflexad.' : 'Nu har du flexat ut.';
              break;
          }
          $flex.find( "p.sum" ).show();
          if (warning) {
            $flex.find( "div.status" ).addClass('warning');
            $flex.find( "p.sum" ).text("Flexsaldo: +5,5 timmar.");
          } else {
            $flex.find( "div.status" ).addClass('success');
            $flex.find( "p.sum" ).text("Nytt flexsaldo: +4,5 timmar.");
          }
        }

        $flex.find( "p.action" ).html( response );
      }, 1500);
    });
  }
});
