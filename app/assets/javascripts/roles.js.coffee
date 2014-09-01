$ ->
  # Check all/none checkbox for role assignment
  $toggleDepartments = $("#toggle-departments")
  $toggleWorkingFields = $("#toggle-working_fields")

  if $toggleDepartments.length
    checkcheck $toggleDepartments, $("#check-departments")

  if $toggleWorkingFields.length
    checkcheck $toggleWorkingFields, $("#check-working_fields")
