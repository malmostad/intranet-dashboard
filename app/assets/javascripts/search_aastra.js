jQuery(document).ready(function($) {

  // Person search form
  var $searchFormAastra = $('#search-aastra-form');

  if ( $searchFormAastra.length ) {
    $searchField = $('#query-person');

    // Route form to Aastra phone catalog in new window
    $searchFormAastra.submit(function(event) {
      event.preventDefault();
      $searchFormAastra.find("label").removeClass("warning");
      var searchUrl = 'http://srvwindccmg02.malmo.se/netwiseoffice/common/newframes.asp?callingButton=FirstSearch&oldsearch=lname,' +  escape($searchField.val()) + '|';
      window.open(searchUrl, "phonebook");
    });
  }
});
