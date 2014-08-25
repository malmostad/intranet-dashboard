$ ->
  # Load more feed entries async on click
  $('.feeds').on "click", '.load-more input', (event) ->
    event.preventDefault()
    getMore $(@)

  # Lazy loading more news when combined news is displayed
  if $('section.combined').length
    currentlyLoading = false
    $(window).on 'DOMContentLoaded load resize scroll', () ->
      rect = $('section.combined')[0].getBoundingClientRect()
      # Lazy load when rect.bottom is visible AND if feeds box hasn't a box to the right,
      # i.e. only in one column layout
      if $(window).width() - rect.right > 50 and rect.bottom <= $(window).height() + 100 and not currentlyLoading
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
