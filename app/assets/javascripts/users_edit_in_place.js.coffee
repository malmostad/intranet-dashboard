# Edit in place for user profile
$ ->
  $submitBtn = $("<input type='submit' class='btn btn-small btn-primary save' value='Spara'>")
  $cancelBtn = $("<button class='btn btn-small cancel'>Avbryt</button>")

  $form = $("#user-edit-in-place")
  $form.find(".editable").on "click", ".change", (event) ->
    event.preventDefault()
    $block = $(@).closest(".controls")

    # Get (the full) form template and inject the form fields from data-edit-id
    $.ajax
      url: $form.attr('data-tmpl-path')
      method: "GET"
      cache: false
    .done (data) ->
      $default = $block.html()
      $formPart = $(data).find("##{$block.attr('id')}")
      $block.html($formPart.html())
      createForm($block, $default)

  cancelEdit = ($block, $default) ->
    $block.html($default)
    $form.find(".change, .change-avatar, .info").show()

  createForm = ($block, $default) ->
    $form.find(".change, .change-avatar, .info").hide()

    # Set focus on first form field
    $block.find("input, select, textarea").focus()

    attachTokenInput()

    $actions = $("<div>").addClass("actions").appendTo($block)
    $actions.append $submitBtn.clone().click (event) ->
      event.preventDefault()
      $.ajax
        url: $form.attr('action')
        method: "POST"
        cache: false
        data: $form.serialize()
      .done (data) ->
        $formPart = $(data).find("##{$block.attr('id')}")
        $block.html($formPart.html())
        if $formPart.find(".warning").length
          createForm($block, $default)
        else
          $form.find(".change, .change-avatar, .info").show()

    # Restore on Cancel
    $actions.append $cancelBtn.clone().click (event) ->
      event.preventDefault()
      cancelEdit($block, $default)

    # Restore on Esc
    $block.on 'keyup', (event) ->
      cancelEdit($block, $default) if event.which is 27


  $form.find(".controls").on "click", ".info", (event) ->
    event.preventDefault()
    $(@).prop("disabled", true)
    alert "Not implemented yet"
