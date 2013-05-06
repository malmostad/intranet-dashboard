// Time report simulation
jQuery(document).ready(function($) {
  var $timeReport = $('#time-report');

  if ($timeReport.length) {
    var $status = $timeReport.find(".status");

    setTimeout(function() {
      $status.text("Flexsaldo: +4,23 timmar.");
    }, 1000);

    $timeReport.find("button").click(function() {
      var action = $(this).attr('data-action');

      $status.addClass('loading')
        .html("Flexar &hellip;" )
        .removeClass('success warning error active');

      $timeReport.find("button").addClass('disabled');

      setTimeout(function() {
        $status.removeClass('loading', 'default');
        $timeReport.find("button").removeClass('disabled');
        var warning = Math.floor( Math.random() * 4) === 3 ? true : false;
        var error = Math.floor( Math.random() * 8) === 3 ? true : false;
        var response;

        if (error) {
          response = 'HRutan gick inte att nå.<br/>Vänligen försök lite senare.';
          $status.addClass('error');
        } else {
          switch (action) {
            case 'in':
              response = warning ? 'Nu blev det fel!<br/> Du är redan inflexad.' : 'Du har flexat in.';
              break;
            case 'break-out':
              response = warning ?  'Nu blev det fel!<br/> Du är redan utrastad.' : "Du har rastat ut.";
              break;
            case 'break-in':
              response = warning ? 'Nu blev det fel!<br/> Du är redan inrastad.' : 'Du har rastat in.';
              break;
            case 'out':
              response = warning ? 'Nu blev det fel!<br/> Du är redan utflexad.' : 'Du har flexat ut.';
              break;
          }
          if (warning) {
            $status.addClass('warning');
          } else {
            $status.addClass('success');
            response += "<br/>Nytt flexsaldo: +4,5 timmar."
          }
        }
        $status.html(response);
      }, 1500);
    });
  }
});