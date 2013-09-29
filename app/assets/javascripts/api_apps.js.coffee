$ ->
  $("#api-apps button.generate-secret").click (event) ->
    event.preventDefault()
    if confirm("Nuvarande app_secret kommer att sluta fungera. Vill du fortsätta?")
      console.log "Ja"
      # TODO: ajax call that triggers new key
