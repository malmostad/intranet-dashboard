# Add and remove colleagues
$ ->
  $colleagues = $('#colleagues')
  if $colleagues.length
    $addTrigger = $("#add-colleague-trigger")
    $field = $('#add_colleague')
    $form = $('#add-colleague-form')
    $fieldset = $form.find('fieldset')
    $list = $colleagues.find('ul.box-content')
    selectedColleagueId = false

    $addTrigger.click (event) ->
      showForm()
      return false # IE7 is very slow with preventDefault here.

    showForm = ->
      $field.val('')
      selectedColleagueId = false
      $fieldset.addClass('show')
      $field.attr('autocomplete',"off").focus()
      $addTrigger.removeClass('show')
      $list.find('.warning').remove()
      selectedUsername = ""

    # Hide the update form
    hideForm = (initial) ->
      $fieldset.removeClass('show')
      $(".add p.help").hide()
      $('#add-colleague-trigger').addClass('show')
      if (!initial)
        $("#add-colleague-trigger").focus()

    $field.focus ->
      # Hide on escape key
      $field.on 'keyup', (e) ->
        if e.which is 27
          hideForm()

    $field.blur ->
      # Release esc key listners
      $field.off('keyup')

    $field.autocomplete
      source: $field.attr("data-path")
      minLength: 2
      autoFocus: true
      appendTo: $field.closest(".box")
      select: (event, ui) ->
        selectedColleagueId = ui.item.id
        $form.submit()
        hideForm()
    .data("ui-autocomplete")._renderItem = (ul, item) ->
      ul.addClass('search_users')
      return $("<li>")
        .data("ui-autocomplete-item", item)
        .append( "<a><img src='" + item.avatar_full_url + "' />" +
           "<p>" + item.first_name + " " + item.last_name +
            "<br/> " + item.company_short + "</p></a>" )
        .appendTo(ul)

    $form.submit (event) ->
      event.preventDefault()
      $newItem = $('<li class="waiting"></li>').insertBefore($list.find('li:last'))
      formData = if !!selectedColleagueId then "colleague_id=#{selectedColleagueId}" else ""
      $.ajax
        type: 'POST'
        url: $form.attr("action")
        data: formData
        success: (data, textStatus, jqXHR) ->
          # Add the colleague to the list
          $newItem.remove()
          $(data).insertBefore($list.find('li:last'))
          hideForm()
        error: (jqXHR, textStatus, errorThrown) ->
          $newItem.replaceWith($('<div class="text"><p class="status warning">Ett fel inträffade. Försök lite senare.</p></div>'))
          hideForm()
        dataType: "html"

    # Change bg on hover
    $list.on "mouseenter mouseleave", ".remove", ->
      $(this).toggleClass("m-icon-close m-icon-close-0")

    # Hide colleague from list when removed (deleting managed by link)
    $list.on 'click', 'a.delete', () ->
      $(this).closest('li').slideUp(100)

    # Start with hiding status form
    if !$('#add-colleague-form fieldset.show.no-colleagues').length
      hideForm(true)
