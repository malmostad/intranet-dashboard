# Autocomplete search for responsibilities
$ ->
  $("#search-responsibility #term").focus().autocomplete
    source: $("#search-responsibility").attr("action")
    minLength: 2
    autoFocus: true
    select: (event, ui) ->
      document.location = $("#search-responsibility").data("path") + "/"  + ui.item.id + '/edit'
