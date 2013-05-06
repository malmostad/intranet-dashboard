// Time report simulation
jQuery(document).ready(function($) {
  var $timeReport = $( '#time-report' );

  if ($timeReport.length) {
    $timeReport.find("button").click(function() {
      var $this = $(this);
      $timeReport.addClass('loading');
      $timeReport.find( "p.action" ).html("Flexar &hellip;" );
      $timeReport.find( "div.status" ).removeClass('success warning error active');
      $timeReport.find( "p.sum" ).hide();

      setTimeout(function() {
        $timeReport.removeClass('loading');

        var warning = Math.floor( Math.random() * 4) === 3 ? true : false;
        var error = Math.floor( Math.random() * 8) === 3 ? true : false;

        var response;
        if (error) {
          response = 'HRutan gick inte att nå!<br/>Vänligen försök lite senare.';
          $timeReport.find( "div.status" ).addClass('error');
          $timeReport.find( "p.sum" ).text("Flexsaldo: +5,5 timmar.");
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
          $timeReport.find( "p.sum" ).show();
          if (warning) {
            $timeReport.find( "div.status" ).addClass('warning');
            $timeReport.find( "p.sum" ).text("Flexsaldo: +5,5 timmar.");
          } else {
            $timeReport.find( "div.status" ).addClass('success');
            $timeReport.find( "p.sum" ).text("Nytt flexsaldo: +4,5 timmar.");
          }
        }

        $timeReport.find( "p.action" ).html(response);
      }, 1500);
    });
  }
});