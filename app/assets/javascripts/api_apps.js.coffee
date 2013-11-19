$ ->
  $("#generate-secret button").click (event) ->
    event.preventDefault()
    if confirm("Nuvarande app_secret kommer att sluta fungera. Vill du fortsätta?")
      $.ajax
        url: $(@).attr('data-path')
        success: (data) ->
          $("#generate-secret").replaceWith data
        error: (jqXHR, textStatus, errorThrown) ->
          $("#generate-secret").after('<p class="warning">Ett fel inträffade. Försök lite senare.<br/>(' + textStatus + " " + errorThrown + ')</p>')

