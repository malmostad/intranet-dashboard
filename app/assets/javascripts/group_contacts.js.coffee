$ ->
  $address = $("#group_contact_visitors_address")
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
              neighborhood: item.towndistrict
              postal_town: item.postal_town
              east: item.east
              north: item.north
      minLength: 2
      select: (event, ui) ->
        $address.val ui.item.address
        $('#group_contact_visitors_address_zip_code').val ui.item.post_code
        $('#group_contact_visitors_address_postal_town').val ui.item.postal_town
        $('#group_contact_visitors_district').val ui.item.neighborhood
        $('#group_contact_visitors_address_geo_position_x').val ui.item.east
        $('#group_contact_visitors_address_geo_position_y').val ui.item.north

    # Don't submit the form on enter key for this field
    $address.keydown (event) ->
      if event.which is 13
        event.preventDefault()

    # Clear retrived fields if address is empty
    $address.blur (event) ->
      if $(@).val().trim() is ""
        $('#group_contact_visitors_address_zip_code').val ""
        $('#group_contact_visitors_address_postal_town').val ""
        $('#group_contact_visitors_district').val ""
        $('#group_contact_visitors_address_geo_position_x').val ""
        $('#group_contact_visitors_address_geo_position_y').val ""
