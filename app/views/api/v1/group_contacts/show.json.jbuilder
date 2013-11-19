json.extract! @group_contact, :id, :name, :email, :phone, :phone_hours, :cell_phone, :fax, :address, :zip_code,
    :postal_town, :homepage, :created_at, :updated_at, :legacy_dn

json.visiting do |v|
  v.address @group_contact.visitors_address
  v.zip_code @group_contact.visitors_address_zip_code
  v.postal_town @group_contact.visitors_address_postal_town
  v.district @group_contact.visitors_district
  v.geo_position do |g|
    g.x @group_contact.visitors_address_geo_position_x
    g.y @group_contact.visitors_address_geo_position_y
  end
  v.hours @group_contact.visiting_hours
end
