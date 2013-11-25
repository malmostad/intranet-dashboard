$ ->
  if $('#full-search').length
    $('#q').focus() unless $('#q').val().length

    # Load more results async
    $(".results").on "click", "#load-more-search-results a", (event) ->
      event.preventDefault()
      $.get $('#load-more-search-results a').attr("href"), (data) ->
        $('#load-more-search-results').replaceWith(data)
      $(this).text("Laddar fler...").addClass('disabled')

  # Autocomplete
  $searchField = $('#full-search #q')
  if $searchField.length
    $searchField.autocomplete
      source: (request, response) ->
        $.ajax
          url: $searchField.attr("data-autocomplete-path")
          data:
            q: request.term
            ilang: 'sv'
          dataType: "jsonp"
          jsonpCallback: "results"
          success: (data) ->
            if data.length
              response $.map data, (item) ->
                return {
                  hits: item.nHits
                  suggestionHighlighted: item.suggestionHighlighted
                  value: item.suggestion
                }
      minLength: 2
      select: (event, ui) ->
        document.location = $("#full-search").attr('action') + '?q=' + unescape(ui.item.value)
    .data( "ui-autocomplete" )._renderItem = (ul, item) ->
      return $("<li></li>")
      .data("ui-autocomplete-item", item)
      .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
      .appendTo(ul)

  # Event tracking of details for selected link in the search results
  if $("section.site-search").length
    $('body').on "click", "section.site-search h2 a, section.site-search .ess-bestbets a, section.site-search ul.breadcrumb a, section.site-search .categories a", (event) ->
      $a = $(this)
      if typeof gaDelayEvent is "function" then gaDelayEvent($a, event)
      link = $a.attr('href')
      GAAction = $("#q").val()
      GALabel = $.trim($a.text()) + " " + link

      # Track all clicks in the results list
      if $a.closest(".results").length > 0
        _gaq.push(['_trackEvent', 'SearchClickPosition', GAAction, GALabel, $(".results > ul > li").index($a.closest("li")) + 1, 10])

      # Track clicks on breadcrumbs in the results list
      if $a.closest(".breadcrumb").length > 0
        _gaq.push(['_trackEvent', 'SearchClickBreadcrumb', GAAction,  GALabel])

      # Track clicks on editors choich in the results list
      if $a.closest(".editors_choice").length > 0
        _gaq.push(['_trackEvent', 'SearchClickEditorsChoice', GAAction,  GALabel])

      # Track clicks on editors choich in the results list
      if $a.closest(".categories").length > 0
        _gaq.push(['_trackEvent', 'SearchClickCategory', GAAction,  GALabel])
