FactoryGirl.define do
  factory :group_contact do
    sequence(:name) { |n| "group_contact-#{n}" }
    # :address, :cell_phone, :email, :fax, :homepage, :name, :phone, :phone_hours, :postal_town, :visiting_hours, :visitors_address, :visitors_address_geo_position_x, :visitors_address_geo_position_y, :visitors_address_postal_town, :visitors_address_zip_code, :visitors_district, :zip_code
  end
end
