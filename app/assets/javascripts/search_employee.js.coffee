jQuery ->
  $queryEmployee = $("#query-employee")
  if $queryEmployee.length
    $queryEmployee
      .autocomplete
        source: $queryEmployee.parents("form").attr("action"),
        minLength: 2,
        select: (event, ui) ->
          document.location = "#{$queryEmployee.data("path")}/#{ui.item.username}"
      .data("ui-autocomplete")
      ._renderItem = (ul, item) ->
        ul.addClass('search_users image-list')
        $("<li class='suggest-users'></li>")
          .data("item.autocomplete", item)
          .append("<a><img src='#{item.avatar_full_url}'/>
              <p>#{item.first_name} #{item.last_name}<br/>
              #{item.company}</p></a>")
          .appendTo(ul)
