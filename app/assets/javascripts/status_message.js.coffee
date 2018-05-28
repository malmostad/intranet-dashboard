# User status message update
$ ->
  $form = $('#update-status-form')
  if $form.length
    $field = $('#status_message')
    $controls = $form.find(".controls")
    $count = $form.find(".count")
    $submit = $form.find("input[type=submit]")
    $myStatus = $('#my-status .status')

    # Hide the update form
    resetForm = ->
      $field.attr('rows', 1).val("").height(19).blur()
      $controls.hide()

    narrow = ->
      $(window).width() <= 480

    # Display left characters count and disable submit button if negative
    # Note: keydown/up will not do, it is possible to perform cut/paste from browser menu
    $field.focus ->
      $controls.show()
      $field.timer = setInterval ->
        showCount($field.val(), 70 )
        autoExpand()
      , 50

      # Hide on escape key
      $field.on 'keyup', (e) ->
        if e.which is 27
          resetForm()

      # Submit on enter, strange in a textarea but it was a very explicit feature request
      $field.on 'keydown', (event) ->
        if event.which is 13
          event.preventDefault()
          if $field.val().length > 1 && $field.val().length <= 70
            $form.submit()

    # Release count and esc key listners
    $field.blur ->
      clearInterval($field.timer)

    # Expand textarea height if we get scrollbars
    autoExpand = ->
      if $field[0].scrollHeight > $field[0].clientHeight
        $field.height(($field.height() + 13) + "px")

    showCount = (chars, limit) ->
      length = chars.length

      $count.html(limit-length)

      if limit - length < 0
        $count.addClass("error")
        $submit.attr('disabled', true)
      else if limit - length < 10
        $count.addClass("warning")
      else
        $count.addClass("success")

    $form.submit (event) ->
      event.preventDefault()
      oldStatus = $myStatus.text()
      # Show new status immediately and close form
      $myStatus.text($field.val())

      # Put status to server and watch out for the repsonse
      $.ajax
        type: 'POST'
        url: $form.attr("action")
        data: $form.serialize()
        success: (data, textStatus, jqXHR) ->
          $myStatus.text(data.status_message).addClass('success') # New status from server, just in case
          $('#my-status .updated_at').text('Precis uppdaterad')
          resetForm()
        error: (jqXHR, textStatus, errorThrown) ->
          $myStatus.after('<p class="warning">Ett fel inträffade. Försök lite senare.' + textStatus + " | " + errorThrown + '</p>')
          $('#my-status .status').text(oldStatus) # Revert to old status
        dataType: "json"
