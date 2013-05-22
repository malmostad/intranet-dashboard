$ ->
  # Check/uncheck roles
  checkcheck = ($toggler, $roles) ->
    allchecked($toggler, $roles)
    $toggler.change ->
      $roles.find(":checkbox").prop("checked", $(@).prop('checked') ? true : false)
    $roles.change ->
      allchecked($toggler, $roles)

  # Check/uncheck the "All" checkbox depending on the role checkbox values
  allchecked = ($toggler, $roles) ->
    if $roles.find(":checkbox:checked").length == $roles.find(":checkbox").length
      $toggler.prop('checked', true)
    else
      $toggler.prop('checked', false)

  # Check all/none checkbox for role assignment
  $toggleDepartments = $("#toggle-departments")
  $toggleWorkingFields = $("#toggle-working_fields")

  if $toggleDepartments.length
    checkcheck $toggleDepartments, $("#check-departments")

  if $toggleWorkingFields.length
    checkcheck $toggleWorkingFields, $("#check-working_fields")
