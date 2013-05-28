$ ->
  # Edit in place
  $form = $("#user-edit-in-place")
  $form.find(".controls[data-edit]").append $("<button class='btn btn-mini change'>Ändra</button>").click (event) ->
    event.preventDefault()
    $trigger = $(@)
    $block = $trigger.closest(".controls")
    $.get "/users/112/edit?mode=edit_in_place", (data) ->
      $block.html($(data).find("#user_business_card_title"))
      $("#user_business_card_title").focus()
      $block.append $("<input type='submit' class='btn btn-small btn-primary save' value='Spara'>").click (event) ->
        console.log "save"
      $block.append $("<button class='btn btn-small cancel'>Avbryt</button>").click (event) ->
        console.log "cancel"
