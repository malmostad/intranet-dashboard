$ ->
  # Search results, load more
  $("section.index.users").on "click", ".load-more input", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')
    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)
