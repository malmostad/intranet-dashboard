jQuery(document).ready(function($) {
  $('#username').focus();

  // Load more feed entries async
  $('.feeds').on("click", '.load-more input', function(event) {
    event.preventDefault();
    $trigger = $(this);
    $trigger.val("Hämtar fler...").addClass('disabled');

    $.get($trigger.attr('data-path'), function(data) {
      $trigger.parent().replaceWith(data);
    });
  });
});
