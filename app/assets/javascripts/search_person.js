jQuery(document).ready(function($) {

  // Person search form
  var $searchFormPerson = $('#search-person-form');

  if ( $searchFormPerson.length ) {
    $searchField = $('#query-person');

    // Route form to Aastra phone catalog in new window
    $searchFormPerson.submit(function(event) {
      event.preventDefault();
      $searchFormPerson.find("label").removeClass("warning");
      var searchUrl = 'http://srvwindccmg02.malmo.se/netwiseoffice/common/newframes.asp?callingButton=FirstSearch&oldsearch=lname,' +  escape($searchField.val()) + '|';
      window.open(searchUrl, "phonebook");
    });
  }
});
