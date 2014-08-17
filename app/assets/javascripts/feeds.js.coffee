$ ->
  # Load more feed entries async
  $('.feeds').on "click", '.load-more input', (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)

  # Lazy loading more news when combined news is displayed
  if $('.more-combined').length
    $(window).on 'DOMContentLoaded load resize scroll', () ->
      rect = $('.more-combined')[0].getBoundingClientRect()
      if rect.top >= 0 and rect.left >= 0 and
        rect.bottom <= (window.innerHeight || $(window).height()) and
        rect.right <= (window.innerWidth || $(window).width())
      then console.log "Load more"
