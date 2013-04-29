jQuery(document).ready(function($) {

  var placeholder = 'Sök person eller information';
  var $searchForm = $("#masthead .search");
  var $searchField = $('#masthead-q');
  var $type = $searchForm.find(".type");

  /**
   * Masthead search form
   * Set listner for placeholder
   */
  $searchField
    .addClass('placeholder')
    .val(placeholder)
    .focus(function() {
      if ($(this).val() == placeholder) {
          $(this).val('').removeClass('placeholder');
      }
    })
    .blur(function() {
      if ($(this).val() === '') {
        $(this).val(placeholder).addClass('placeholder');
      }
  });

  // Show/hide search type controls on some events
  $searchForm.find('input').bind('focus keydown click', function() {
    $(this).attr('autocomplete',"off");
    $searchForm.addClass('show');

    // Hide on click outside the box
    $(document).on('click', function() {
      cancelSearch();
    });
    // Don't hide on click in the box
    $searchForm.click(function(event){
      event.stopPropagation();
    });

    // Hide on escape key
    $(document).on('keyup', function(e) {
      if (e.which == 27) {
        cancelSearch();
      }
    });

    // Hide on cancel link
    $searchForm.find(".cancel").click(function() {
      cancelSearch();
    });
  });

  // Close the search box and unbind the events
  function cancelSearch() {
    $searchForm.removeClass('show');
    $(document).off('keyup');
    $(document).off('click');
  }

  /*
   * Route form to phone catalog or intranet web search
   */
  $searchForm.submit(function(event) {
    submitForm(event);
  });

  // Regular link for formatting issues
  $searchForm.find('.button').click(function(event) {
    submitForm(event);
  });

  function submitForm(event) {
    event.preventDefault();
    var query = $searchField.val() == placeholder ? '' : escape($searchField.val());

    if ( $("#search-type_person").attr('checked') ) {
      var url = 'http://srvwindccmg02.malmo.se/netwiseoffice/common/newframes.asp?callingButton=FirstSearch&oldsearch=lname,' +  query + '|';
      window.open(url, "_blank");
    } else {
      // Komin2 search
      document.location = 'http://komin.malmo.se/sok?q=' + unescape(query);
    }
  }

});
