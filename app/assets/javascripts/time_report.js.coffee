# Time report simulation
$ ->
  $timeReport = $('#time-report')

  if $timeReport.length
    $status = $timeReport.find(".status")

    setTimeout () ->
      $status.text "Flexsaldo: +4,23 timmar."
    , 1000

    $timeReport.find("button").click () ->
      action = $(this).attr('data-action')

      $status.addClass('loading')
        .html("Flexar &hellip;" )
        .removeClass('success warning error active')

      $timeReport.find("button").addClass('disabled')

      setTimeout () ->
        $status.removeClass('loading', 'default')
        $timeReport.find("button").removeClass('disabled')

        warning = if Math.floor( Math.random() * 8) is 3 then true else false
        error   = if Math.floor( Math.random() * 12) is 3 then true else false
        response
        warnMsg = "Nu blev det fel!<br/> Du är redan"

        if error
          response = 'HRutan gick inte att nå.<br/>Vänligen försök lite senare.'
          $status.addClass('error')
        else
          switch action
            when 'in'
              response = if warning then "#{warnMsg} inflexad." else 'Du har flexat in.'
              break
            when 'break-out'
              response = if warning then "#{warnMsg} utrastad." else "Du har rastat ut."
              break
            when 'break-in'
              response = if warning then "#{warnMsg} inrastad." else 'Du har rastat in.'
              break
            when 'out'
              response = if warning then "#{warnMsg} utflexad." else 'Du har flexat ut.'
              break

          if warning
            $status.addClass('warning')
          else
            $status.addClass('success')
            response += "<br/>Nytt flexsaldo: +4,5 timmar."

        $status.html(response)
      , 1500
