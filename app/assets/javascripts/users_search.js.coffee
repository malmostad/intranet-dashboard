$ ->
  # Autocomplete on user search
  $queryEmployee = $("#query-employee")
  if $queryEmployee.length
    $queryEmployee
      .autocomplete
        source: $queryEmployee.parents("form").attr("action")
        minLength: 2
        appendTo: $queryEmployee.closest(".box")
        select: (event, ui) ->
          document.location = "#{$queryEmployee.data("path")}/#{ui.item.username}"
      .data("ui-autocomplete")
      ._renderItem = (ul, item) ->
        ul.addClass('search_users')
        if $queryEmployee.hasClass("full-search")
          ul.addClass('full-search')
        $("<li>")
          .data("item.autocomplete", item)
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
