$ ->
  # Load more feed entries async
  $('.feeds').on "click", '.load-more input', (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)
