$ ->
  # Autocomplete on user search
  $queryEmployee = $("#query-employee")
  if $queryEmployee.length
    $queryEmployee.autocomplete
      source: (request, response) ->
        $.ajax
          url: $queryEmployee.attr("data-autocomplete-url").replace("http:", location.protocol)
          data:
            term: request.term.toLowerCase()
          dataType: "jsonp"
          timeout: 5000
          success: (data) ->
            if data.length
              response $.map data, (item) ->
                item
      minLength: 2
      select: (event, ui) ->
        document.location = ui.item.path
    .data("ui-autocomplete")._renderItem = (ul, item) ->
      ul.addClass('search_users')
      if $queryEmployee.hasClass("full-search")
        ul.addClass('full-search')
      $("<li>")
        .data("ui-autocomplete-item", item)
        .append("<a><img src='#{item.avatar_full_url}'/>
            <p>#{item.first_name} #{item.last_name}<br>
            #{item.company_short}<br>
            #{item.department}</p></a>
        ")
        .appendTo(ul)


  # Search results, load more
  $("section.index.users").on "click", ".load-more input", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')
    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)
