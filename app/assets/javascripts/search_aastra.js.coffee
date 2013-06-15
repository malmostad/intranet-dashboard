# Route form to Aastra phone catalog in new window
$ ->
  $searchFormAastra = $('#search-aastra-form')

  if $searchFormAastra.length
    $searchField = $('#query-person')
    $searchFormAastra.submit (event) ->
      event.preventDefault()
      $searchFormAastra.find("label").removeClass("warning")
      searchUrl = "http://srvwindccmg02.malmo.se/netwiseoffice/common/newframes.asp?callingButton=FirstSearch&oldsearch=lname,#{escape $searchField.val()}|"
      window.open searchUrl, "phonebook"
