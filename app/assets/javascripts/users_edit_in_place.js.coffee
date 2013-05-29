# Edit in place for user profile
$ ->
  $submitBtn = $("<input type='submit' class='btn btn-small btn-primary save' value='Spara'>")
  $cancelBtn = $("<button class='btn btn-small cancel'>Avbryt</button>")

  $form = $("#user-edit-in-place")
  $form.find(".editable").on "click", ".change", (event) ->
    event.preventDefault()
    $form.find(".editable .change").hide()
    $block = $(@).closest(".controls")

    # Get (the full) form template and inject the form fields from data-edit-id
    $.ajax
      url: $form.attr('data-tmpl-path')
      method: "GET"
      cache: false
    .done (data) ->
      $default = $block.html()
      $formPart = $(data).find("##{$block.attr('id')}").html()
      $block.html($formPart)

      # Set focus on first form field
      $block.find("input, select, textarea").focus()

      $actions = $("<div>").addClass("actions").appendTo($block)
      $actions.append $submitBtn.clone().click (event) ->
        event.preventDefault()
        $.ajax
          url: $form.attr('action')
          method: "POST"
          cache: false
          data: $form.serialize()
        .done (data) ->
          $formPart = $(data).find("##{$block.attr('id')}").html()
          $block.html($formPart)
          $form.find(".editable .change").show()

      # Restore on Cancel
      $actions.append $cancelBtn.clone().click (event) ->
        event.preventDefault()
        cancelEdit()

      # Restore on Esc
      $block.on 'keyup', (event) ->
        cancelEdit() if event.which is 27

      cancelEdit = () ->
          $block.html $default
          $form.find(".editable .change").show()
