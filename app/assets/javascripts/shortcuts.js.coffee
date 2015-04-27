# Add and remove shortcuts
$ ->
  $list = $('#shortcuts-tools, #shortcuts-i-want')
  # Change bg on hover
  $list.on "mouseenter mouseleave", ".remove", ->
    $(this).toggleClass("m-icon-close m-icon-close-0")

  # Hide colleague from list when removed (deleting managed by link)
  $list.on 'click', 'a.remove', () ->
    $(this).closest('li').slideUp(100)
