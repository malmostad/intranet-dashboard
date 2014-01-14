$ ->
  $searchField = $("#merge-language #into")
  if $searchField.length
    $searchField.autocomplete
      source: (request, response) ->
        $.ajax
          url: $searchField.attr("data-search-path")
          data:
            into: request.term
          dataType: "json"
          jsonpCallback: "results"
          success: (data) ->
            response $.map data, (item) ->
              label: item.name
              value: item.name
