# -*- coding: utf-8 -*-

class GroupContact < ActiveRecord::Base
  attr_accessible :address, :cell_phone, :email, :fax, :homepage, :name, :phone, :phone_hours, :postal_town, :visiting_hours, :visitors_address, :visitors_address_geo_position_x, :visitors_address_geo_position_y, :visitors_address_postal_town, :visitors_address_zip_code, :visitors_district, :zip_code

  validates_presence_of :name

  before_validation do
    self.homepage = "http://#{homepage}" unless homepage.blank? || homepage.match(/^https?:\/\//)
    self.phone.gsub!(/\s*-\s*/, "-")
    self.cell_phone.gsub!(/\s*-\s*/, "-")
    self.fax.gsub!(/\s*-\s*/, "-")
    self.phone_hours.gsub!(/\s*-\s*/, "–")
    self.visiting_hours.gsub!(/\s*-\s*/, "–")
  end
end
