$ ->
  # Autocomplete search for skills
  $("#search-skill #term").focus().autocomplete
    source: $("#search-skill").attr("action")
    minLength: 2
    autoFocus: true
    select: (event, ui) ->
      document.location = $("#search-skill").data("path") + "/" + ui.item.id + '/edit'

  $searchField = $("#merge-skill #into")
  if $searchField.length
    $searchField.autocomplete
      minLength: 2
      source: (request, response) ->
        $.ajax
          url: $searchField.attr("data-search-path")
          data:
            into: request.term
          dataType: "json"
          jsonpCallback: "results"
          success: (data) ->
            response $.map data, (item) ->
              label: item.value
              value: item.value
