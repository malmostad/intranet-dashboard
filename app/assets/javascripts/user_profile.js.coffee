$ ->
  $('#skills').select2()

  $('#languages').select2
    ajax:
      url: "/skills/search",
      dataType: 'jsonp',
      data: (term) ->
        return {
          q: term
          page_limit: 10
        }
      results: (data) ->
        return {results: data.movies}
