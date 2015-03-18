$ ->
  $('#start-search-intranet').focus()
  if $('#full-search').length

    # Load more results async
    $(".results").on "click", "#load-more-search-results a", (event) ->
      event.preventDefault()
      $.get $('#load-more-search-results a').attr("href"), (data) ->
        $('#load-more-search-results').replaceWith(data)
      $(this).text("Laddar fler...").addClass('disabled')

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
          ga('send', 'event', 'SearchClickPosition', GAAction, GALabel, $(".results > ul > li").index($a.closest("li")) + 1, 10)

        # Track clicks on breadcrumbs in the results list
        if $a.closest(".breadcrumb").length > 0
          ga('send', 'event', 'SearchClickBreadcrumb', GAAction,  GALabel)

        # Track clicks on editors choich in the results list
        if $a.closest(".editors_choice").length > 0
          ga('send', 'event', 'SearchClickEditorsChoice', GAAction,  GALabel)

        # Track clicks on editors choich in the results list
        if $a.closest(".categories").length > 0
          ga('send', 'event', 'SearchClickCategory', GAAction,  GALabel)
