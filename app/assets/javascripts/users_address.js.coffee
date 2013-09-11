$ ->
  $address = $("#user_address")
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
              label: item.name + ", " + item.district
              value: item.name
              address: item.name
              post_code: item.postcode
              neighborhood: item.towndistrict
              postal_town: item.postal_town
              east: item.east
              north: item.north
      minLength: 2
      select: (event, ui) ->
        $('#user_address').val ui.item.address
        $('#user_post_code').val ui.item.post_code
        $('#user_postal_town').val ui.item.postal_town
        $('#user_neighborhood').val ui.item.neighborhood
        $('#user_geo_position_x').val ui.item.east
        $('#user_geo_position_y').val ui.item.north
      open: () ->
        $(@).removeClass("ui-corner-all").addClass("ui-corner-top")
      close: () ->
        $(@).removeClass("ui-corner-top").addClass("ui-corner-all")

    # Don't submit the form on enter key for this field
    $('#user_address').keydown (event) ->
      if event.which is 13
        event.preventDefault()
