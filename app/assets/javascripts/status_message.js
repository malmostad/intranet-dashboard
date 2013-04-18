// User status message update
jQuery(document).ready(function($) {

  var $form = $('#update-status-form');
  if ( $form.length ) {
    var $field = $('#status_message');
    var $fieldset = $form.find("fieldset");
    var $controls = $form.find(".controls");
    var $count = $form.find(".count");
    var $submit = $form.find("input[type=submit]");
    var $cancel = $form.find('.cancel');
    var $myStatus = $('#my-status .status');
    var viewportContent = $("meta[name=viewport]").attr("content");

    // Hide the update form
    var resetForm = function() {
      $field.attr('rows', 1).val("").height("1.5em").blur();
      $controls.hide();
    };

    var narrow = function() {
      return ( $(window).width() <= 480 );
    }

    // Display left characters count and disable submit button if negative
    // Note: keydown/up will not do, it is possible to perform cut/paste from browser menu
    $field.focus(function() {
      $controls.show();
      $field.timer = setInterval( function() {
        showCount($field.val(), 70 );
        autoExpand();
      }, 50);

      // Minor narrow device adjustments on focus
      if ( narrow() ) $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=1');

      // Hide on escape key
      $field.on('keyup', function(e) {
        if (e.which == 27) {
          resetForm();
        }
      });
      // Submit on enter, strange in a textarea but it was a very explicit feature request
      $field.on('keydown', function(event) {
        if (event.which == 13) {
          event.preventDefault();
          if ( $field.val().length > 1 && $field.val().length <= 70 ) {
            $form.submit();
          }
        }
      });
    });

    // Release count and esc key listners
    $field.blur(function() {
      clearInterval($field.timer);
      // Reset viewport
      if ( narrow() )  $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=10');
    });

    // Expand textarea height if we get scrollbars
    var autoExpand = function () {
      if ( $field[0].scrollHeight > $field[0].clientHeight )  {
        $field.height(($field.height() + 13) + "px");
      }
    };

    var showCount = function ( chars, limit ) {
      var length = chars.length;

      $count.html(limit - length);

      if ( chars.replace(/\s/g, "").length === 0 ) { // Don't allow empty updates
        $submit.attr('disabled', true);
      } else {
        $submit.attr('disabled', false);
      }

      if ( limit - length < 0 ) {
        $count.addClass("error");
        $submit.attr('disabled', true);
      }
      else if ( limit - length < 10 ) {
        $count.addClass("warning");
      } else {
        $count.addClass("success");
      }
    };

    $form.submit( function(event) {
      event.preventDefault();
      oldStatus = $myStatus.text();
      // Show new status immediately and close form
      $myStatus.text($field.val());

      // Put status to server and watch out for the repsonse
      $.ajax({
        type: 'POST',
        url: $form.attr("action"),
        data: $form.serialize(),
        success: function(data, textStatus, jqXHR) {
          $myStatus.text(data.status_message).addClass('success'); // New status from server, just in case
          $('#my-status .updated_at').text('Precis uppdaterad');
          resetForm();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          $myStatus.after('<p class="warning">Ett fel inträffade. Försök lite senare.' + textStatus + " | " + errorThrown + '</p>');
          $('#my-status .status').text(oldStatus); // Revert to old status
        },
        dataType: "json"
      });
    });
  }
});


  // Minor small device adjustments
  if ( $(window).width() <= 480 ) {
    // Temporarily disable zoom on text field focus
    $('input')
      .focus( function() {
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=1');
      })
      .blur( function() {
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=10');
      }
    );
  }
