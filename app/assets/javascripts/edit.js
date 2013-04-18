jQuery(document).ready(function($) {

  // Check all/none checkbox for role assignment
  var $toggleDepartments = $("#toggle-departments");
  var $toggleWorkingFields = $("#toggle-working_fields");
  if ( $toggleDepartments.length ) {
    checkcheck($toggleDepartments, $("#check-departments"));
  }
  if ( $toggleDepartments.length ) {
    checkcheck($toggleWorkingFields, $("#check-working_fields"));
  }

  // Check/uncheck roles
  function checkcheck($toggler, $roles) {
    allchecked($toggler, $roles);
    $toggler.change( function() {
      $roles.find(":checkbox").attr("checked", $(this).is(':checked') ? true : false);
    });
    $roles.change( function() {
      allchecked($toggler, $roles);
    });
  }

  // Check/uncheck the "All" checkbox depending on the role checkbox values
  function allchecked($toggler, $roles) {
    if ( $roles.find(":checkbox:checked").length === $roles.find(":checkbox").length ) {
      $toggler.attr("checked", true);
    } else {
      $toggler.attr("checked", false);
    }
  }
});
