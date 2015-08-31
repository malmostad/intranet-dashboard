# Remove shortcuts
$ ->
  $list = $('#shortcuts-tools ul li, #shortcuts-i-want ul li')

  # Change bg on hover
  $list.on 'mouseenter mouseleave', '.remove', ->
    $(this).toggleClass('m-icon-close m-icon-close-0')

  # Hide item from list when removed
  $list.on 'click', 'a.remove', () ->
    $(this).closest('li').slideUp(100)
