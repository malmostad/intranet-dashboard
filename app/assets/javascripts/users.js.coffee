$ ->
  # Focus on login form
  $('#username').focus();

  # Show info for non editable field
  $("#edit-user .show-more-info").click (event) ->
    event.preventDefault()
    $(@).closest(".control-group").find(".more-info").slideToggle(100)
    $(@).text( if $(@).text() is "(info)" then "(dölj)" else "(info)" )

  # Tokenized input fields
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

  # Follow colleague on profile page
  $("section.show.user .colleagueship").on "click",  ".add", (event) ->
    $trigger = $(@)
    event.preventDefault()
    $.ajax
      type: 'POST'
      dataType: "json"
      url: $trigger.attr("data-path")
      data:
        colleague_id: $trigger.attr("data-user-id")
      success: (data, textStatus, jqXHR) ->
        $trigger
          .addClass("remove btn-danger")
          .removeClass("add btn-primary")
          .text("Följer")
          .attr("data-colleagueship-id", data.colleagueship_id)

  # Unfollow colleague
  $("section.show.user .colleagueship").on "click",  ".remove", (event) ->
    $trigger = $(@)
    event.preventDefault()
    $.ajax
      type: 'DELETE'
      dataType: "json"
      url: "#{$trigger.attr('data-path')}/#{$trigger.attr("data-colleagueship-id")}"
      success: (data, textStatus, jqXHR) ->
        $trigger
          .addClass("add btn-primary")
          .removeClass("btn-danger remove")
          .text("Följ")
          .attr("data-colleagueship-id", null)

  # Unfollow colleague, visual cue
  $("section.show.user .colleagueship").on "mouseover focus", ".remove", ->
    $(@).addClass("btn-danger").text("Sluta följ")
  $("section.show.user .colleagueship").on "mouseleave blur", ".remove", ->
    $(@).removeClass("btn-danger").text("Följer")
