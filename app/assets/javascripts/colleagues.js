// Add and remove colleagues
jQuery(document).ready(function($) {
  var $colleagues = $('#colleagues');
  if ( $colleagues.length ) {
    var $addTrigger = $("#add-colleague-trigger");
    var $field = $('#add_colleague');
    var $form = $('#add-colleague-form');
    var $fieldset = $form.find('fieldset');
    var $submit = $form.find("input[type=submit]");
    var $cancel = $form.find('.cancel');
    var $list = $colleagues.find('ul.box-content');
    var selectedColleagueId;

    $addTrigger.click( function(event) {
      showForm();
      return false; // IE7 is very slow with preventDefault here.
    });

    var showForm = function() {
      $field.val('');
      selectedColleagueId = false;
      $fieldset.addClass('show');
      $field.attr('autocomplete',"off").focus();
      $addTrigger.removeClass('show');
      $list.find('.warning').remove();
      selectedUsername = "";
    };

    // Hide the update form
    var hideForm = function(initial) {
      $fieldset.removeClass('show');
      $(".add p.help").hide();
      $('#add-colleague-trigger').addClass('show');
      if (!initial) {
        $("#add-colleague-trigger").focus();
      }
    };

    $field.focus(function() {
      // Hide on escape key
      $field.on('keyup', function(e) {
        if (e.which == 27) {
          hideForm();
        }
      });
    });

    $field.blur(function() {
      // Release esc key listners
      $field.off('keyup');
    });

    $field.autocomplete({
      source: $field.attr("data-path"),
      minLength: 2,
      autoFocus: true,
      select: function( event, ui ) {
        selectedColleagueId = ui.item.id;
        $form.submit();
        hideForm();
      }
    })
    .data( "autocomplete" )._renderItem = function( ul, item ) {
      ul.addClass('search_users');
      return $("<li>")
        .data( "item.autocomplete", item )
        .append( "<a><img src='" + item.avatar_full_url + "' />" +
           "<p>" + item.first_name + " " + item.last_name +
            "<br/> " + item.company_short + "</p></a>" )
        .appendTo( ul );
    };

    $form.submit(function(event) {
      event.preventDefault();
      var $newItem = $('<li class="waiting"></li>').insertBefore( $list.find('li:last') );
      var formData = !!selectedColleagueId ? ("colleague_id=" + selectedColleagueId) : ""
      $.ajax({
        type: 'POST',
        url: $form.attr("action"),
        data: formData,
        success: function(data, textStatus, jqXHR) {
          // Add the colleague to the list
          $newItem.remove();
          $(data).insertBefore( $list.find('li:last') );
          hideForm();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          $newItem.replaceWith($('<div class="text"><p class="status warning">Ett fel inträffade. Försök lite senare.</p></div>'));
          hideForm();
        },
        dataType: "html"
      });
    });

    // Hide colleague from list when removed (deleting managed by link)
    $list.on('click', 'a.delete', function() {
      $(this).closest('li').slideUp(100);
    });
    // Start with hiding status form
    if ( !$('#add-colleague-form fieldset.show.no-colleagues').length ) {
      hideForm(true);
    }
  }
});
