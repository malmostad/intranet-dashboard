$ ->
  $activities = $("#user-activities")
  if $activities.length
    $.get $activities.attr('data-path'), (activities) ->
      if activities.length
        $ul = $activities.append("<ul>")
        $.each activities, (i, activity) ->
          $ul.append $("<li>").text("#{activity.reason} #{activity.from_date_time} till #{activity.to_date_time}")
