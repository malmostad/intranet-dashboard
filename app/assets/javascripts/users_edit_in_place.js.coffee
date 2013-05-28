# Edit in place for user profile
$ ->
  $submitBtn = $("<input type='submit' class='btn btn-small btn-primary save' value='Spara'>")
  $cancelBtn = $("<button class='btn btn-small cancel'>Avbryt</button>")

  $form = $("#user-edit-in-place")
  $form.find(".editable").on "click", ".change", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $block = $trigger.closest(".controls")

    $.ajax
      url: "#{$form.attr('data-tmpl-path')}?mode=in_place"
      method: "GET"
      cache: false
    .done (data) ->
      $default = $block.html()
      $formPart = $(data).find("##{$trigger.attr('data-edit-id')}").closest(".controls").html()
      $block.html($formPart)

      $block.find("input, select, textarea").focus()

      $actions = $("<div>").addClass("actions").appendTo($block)
      $actions.append $submitBtn.clone().click (event) ->
        event.preventDefault()
        console.log "save"

      $actions.append $cancelBtn.clone().click (event) ->
        event.preventDefault()
        $block.html $default
        console.log "cancel"

    $form.submit (event) ->
      event.preventDefault()
      console.log "submitting"
      $.ajax
        url: $form.attr("action")
        method: "PUT"
        data: $form.serialize()
        done: (data) ->
          console.log data
