$ ->
  $address = $("#switchboard-changes #address")
  if $address.length
    # Autocomplete search on SBK's address API
    $address.autocomplete
      source: (request, response) ->
        $.ajax
          url: "//kartor.malmo.se/api/v1/addresses/"
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
