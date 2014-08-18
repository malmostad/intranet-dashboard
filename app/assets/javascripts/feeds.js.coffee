$ ->
  # Load more feed entries async on click
  $('.feeds').on "click", '.load-more input', (event) ->
    event.preventDefault()
    getMore $(@)

  # Lazy loading more news when combined news is displayed
  if $('#combined').length
    currentlyLoading = false
    $(window).on 'DOMContentLoaded load resize scroll', () ->
      if $('#combined')[0].getBoundingClientRect().bottom <= $(window).height() + 100 and not currentlyLoading
        getMore $(".load-more input")


  # Load and inject more feed entries
  getMore = ($trigger, url) ->
    currentlyLoading = true
    $trigger.val("Hämtar fler...").addClass('disabled')

    $.ajax
      url: $trigger.attr('data-path')
      timeout: 10000
      success: (data) ->
        $trigger.parent().replaceWith(data)
      error: (x, y, z) ->
        $trigger.parent().html('<div class="error">Ett fel inträffade, prova att ladda om webbsidan</div>')
      complete: ->
        currentlyLoading = false
        $trigger.val("Visa fler").removeClass('disabled')

