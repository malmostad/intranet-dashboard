$ ->
  # Check/uncheck roles
  checkcheck = ($toggler, $roles) ->
    allchecked($toggler, $roles)
    $toggler.change ->
      $roles.find(":checkbox").attr("checked", $(@).is(':checked') ? true : false)
    $roles.change ->
      allchecked($toggler, $roles)

  # Check/uncheck the "All" checkbox depending on the role checkbox values
  allchecked = ($toggler, $roles) ->
    if $roles.find(":checkbox:checked").length == $roles.find(":checkbox").length
      $toggler.attr("checked", true)
    else
      $toggler.attr("checked", false)

  # Check all/none checkbox for role assignment
  $toggleDepartments = $("#toggle-departments")
  $toggleWorkingFields = $("#toggle-working_fields")

  if $toggleDepartments.length
    checkcheck $toggleDepartments, $("#check-departments")

  if $toggleWorkingFields.length
    checkcheck $toggleWorkingFields, $("#check-working_fields")
