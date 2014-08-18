$ ->
  # Load more feed entries async
  $('.feeds').on "click", '.load-more input', (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)

  # Lazy loading more news when combined news is displayed
  if $('#combined').length
    $(window).on 'DOMContentLoaded load resize scroll', () ->
      if $('#combined')[0].getBoundingClientRect().bottom <= $(window).height()
        console.log "Load more"
