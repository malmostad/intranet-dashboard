$ ->
  # Focus on login form
  $('#username').focus();

  # Autocomplete on user search
  $queryEmployee = $("#query-employee")
  if $queryEmployee.length
    $queryEmployee
      .autocomplete
        source: $queryEmployee.parents("form").attr("action")
        minLength: 2
        select: (event, ui) ->
          document.location = "#{$queryEmployee.data("path")}/#{ui.item.username}"
      .data("ui-autocomplete")
      ._renderItem = (ul, item) ->
        ul.addClass('search_users')
        if $queryEmployee.hasClass("full-search")
          ul.addClass('full-search')
        $("<li>")
          .data("item.autocomplete", item)
          .append("<a><img src='#{item.avatar_full_url}'/>
              <p>#{item.first_name} #{item.last_name}<br/>
              #{item.company_short}</p></a>")
          .appendTo(ul)

  # Follow colleague
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

  # Search results, load more
  $("section.index.users").on "click", ".load-more input", (event) ->
    event.preventDefault()
    $trigger = $(@)
    $trigger.val("Hämtar fler...").addClass('disabled')
    $.get $trigger.attr('data-path'), (data) ->
      $trigger.parent().replaceWith(data)

  attachTokenInput()

# Tokenized input fields
window.attachTokenInput = () ->
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

