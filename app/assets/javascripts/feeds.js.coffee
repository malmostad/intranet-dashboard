$ ->
  # Load more feed entries async on click
  $('.feeds').on "click", '.load-more input', (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)

  # Lazy loading more news when combined news is displayed
  if $('#combined').length
    currentlyLoading = false
    $(window).on 'DOMContentLoaded load resize scroll', () ->
      if $('#combined')[0].getBoundingClientRect().bottom <= $(window).height() + 100 and not currentlyLoading
        currentlyLoading = true
        $trigger = $(".load-more input")
        $trigger.val("Hämtar fler...").addClass('disabled')

        $.get $trigger.attr('data-path'), (data) ->
          $trigger.parent().replaceWith(data)
          currentlyLoading = false


# TODO: replace $.get with $.ajax and catch errors (redirs to sso)
