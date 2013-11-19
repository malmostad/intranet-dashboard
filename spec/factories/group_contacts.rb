# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :group_contact do
    sequence(:name) { |n| "group_contact-#{n}" }
    email "email@example.org"
    phone "040-12 31 23"
    cell_phone "040-12 31 23"
    fax "040-12 31 23"
    phone_hours "foo"
    homepage "www.example.org"
    address "foo"
    zip_code "211 00"
    postal_town "Malmö"
    visitors_address "foo"
    visitors_address_zip_code "211 01"
    visitors_address_postal_town "Malmö"
    visitors_address_geo_position_x "12"
    visitors_address_geo_position_y "21"
    visitors_district "foo"
    visiting_hours "bar"
  end
end
