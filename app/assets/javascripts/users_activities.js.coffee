$ ->
  $activities = $("#user-activities")
  if $activities.length
    $.get $activities.attr('data-path'), (activities) ->
      $ul = $activities.replaceWith(activities)
