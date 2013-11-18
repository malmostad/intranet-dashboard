json.extract! @group_contact, :id, :name, :email, :phone, :phone_hours, :cell_phone, :fax, :address, :zip_code,
    :postal_town, :homepage, :created_at, :updated_at, :legacy_dn

json.visitors_address do
  json.address @group_contact.visitors_address
  json.zip_code @group_contact.visitors_address_zip_code
  json.postal_town @group_contact.visitors_address_postal_town
  json.district @group_contact.visitors_district
  json.geo_position do
    json.east @group_contact.visitors_address_geo_position_x
    json.north @group_contact.visitors_address_geo_position_y
  end
  json.visiting_hours @group_contact.visiting_hours
end
