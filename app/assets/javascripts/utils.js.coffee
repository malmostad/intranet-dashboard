# Check/uncheck checkboxes in $within when $toggler is changed
window.checkcheck = ($toggler, $within) ->
  allchecked($toggler, $within)
  $toggler.change ->
    $within.find(":checkbox").prop("checked", $(@).prop('checked') ? true : false)
  $within.change ->
    allchecked($toggler, $within)

# Check/uncheck the $toggler checkbox if all/none checkboxes in $within are checked
window.allchecked = ($toggler, $within) ->
  if $within.find(":checkbox:checked").length == $within.find(":checkbox").length
    $toggler.prop('checked', true)
  else
    $toggler.prop('checked', false)

