$ ->
  # Autocomplete search for skills
  $("#search-skill #term").focus().autocomplete
    source: $("#search-skill").attr("action")
    minLength: 2
    autoFocus: true
    select: (event, ui) ->
      document.location = $("#search-skill").data("path") + "/" + ui.item.id + '/edit'
