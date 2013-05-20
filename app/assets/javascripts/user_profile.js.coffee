jQuery ->
  $form = $("#user-profile")

  $form.find(".controls.read .change").click () ->
    $group = $(@).parents(".control-group")
    $group.find(".controls.edit, .controls.read").toggle()

  $form.find(".controls.edit .submit").click () ->
    $group = $(@).parents(".control-group")
    $group.find(".controls.edit, .controls.read").toggle()

  $form.find(".controls.edit .cancel").click () ->
    $group = $(@).parents(".control-group")
    $group.find(".controls.edit, .controls.read").toggle()

  $form.submit (event) ->
    event.preventDefault()
    $.ajax
      type: 'PUT'
      url: $form.attr("action")
      data: $form.serialize()
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
        console.log("success")
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(jqXHR.responseText)

  # Shared options for tokenInput
  tokenInputOptions = {
    theme: 'malmo'
    searchDelay: 0
    minChars: 2
    allowTabOut: true
    animateDropdown: false
  }

  $('#user_language_list').tokenInput(
    $('#user_language_list').data("path"), $.extend({
      prePopulate: $('#user_language_list').data('load')
      hintText: "Lägg till språk"
    }, tokenInputOptions)
  )

  $('#user_skill_list').tokenInput(
    $('#user_skill_list').data("path"), $.extend({
      prePopulate: $('#user_skill_list').data('load')
      hintText: "Lägg till kunskapsområde"
    }, tokenInputOptions)
  )

  $('#user_responsibility_list').tokenInput(
    $('#user_responsibility_list').data("path"), $.extend({
      prePopulate: $('#user_responsibility_list').data('load')
      hintText: "Lägg till ansvarsområde"
    }, tokenInputOptions)
  )
