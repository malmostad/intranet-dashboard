$ ->
  # Focus on login form
  $('#username').focus();

  # Show info for non editable field
  $("#edit-user .show-more-info").click (event) ->
    event.preventDefault()
    $(@).closest(".form-group").find(".more-info").toggle()
    $(@).text( if $(@).text() is " (info)" then " (dölj)" else " (info)" )

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

  $('#user_activity_list').tokenInput(
    $('#user_activity_list').data("path"), $.extend({
      prePopulate: $('#user_activity_list').data('load')
      hintText: "Lägg till projekt eller aktivitet"
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
    $(@).addClass("btn-default").removeClass("btn-danger").text("Följer")


  $address = $("#edit-user #user_search_address")
  if $address.length
    # Autocomplete search on SBK's address API
    $address.autocomplete
      source: (request, response) ->
        $.ajax
          url: "//xyz.malmo.se/rest/1.0/addresses/"
          dataType: "jsonp"
          data:
            q: request.term
            items: 25
          success: (data) ->
            response $.map data.addresses, (item) ->
              label: item.name
              value: item.name
              address: item.name
              post_code: item.postcode
              district: item.towndistrict
              postal_town: item.postal_town
              east: item.east
              north: item.north
      minLength: 2
      select: (event, ui) ->
        $('#user_address').val(ui.item.address).addClass("success")
        $('#user_post_code').val(ui.item.post_code).addClass("success")
        $('#user_postal_town').val(ui.item.postal_town).addClass("success")
        $('#user_district').val(ui.item.district).addClass("success")
        $('#user_geo_position_x').val ui.item.east
        $('#user_geo_position_y').val ui.item.north
      open: () ->
        $(@).removeClass("ui-corner-all").addClass("ui-corner-top")
      close: () ->
        $(@).removeClass("ui-corner-top").addClass("ui-corner-all")
    .blur ->
      $(@).val ""

    # Don't submit the form on enter key for this field
    $address.keydown (event) ->
      if event.which is 13
        event.preventDefault()

  # Batch assign an activity/project to a list of users in
  $batchActivity = $('#batch-activity')
  $batchActivity.autocomplete
    position:
      collision: "flip"
    source: (request, response) ->
      $.ajax
        url: $batchActivity.attr("data-path")
        dataType: "json"
        data:
          q: request.term
          items: 10
        success: (data) ->
          response $.map data, (item) ->
            value: item.name

    minLength: 2

  # Check/uncheck all
  $toggleUsers = $("#toggle-users")
  if $toggleUsers.length
    checkcheck $toggleUsers, $("ul.results")
