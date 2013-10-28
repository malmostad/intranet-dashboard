# -*- coding: utf-8 -*-

class GroupContact < ActiveRecord::Base
  attr_accessible :address, :cell_phone, :email, :fax, :homepage, :name, :phone, :phone_hours, :postal_town, :visiting_hours, :visitors_address, :visitors_address_geo_position_x, :visitors_address_geo_position_y, :visitors_address_postal_town, :visitors_address_zip_code, :visitors_district, :zip_code

  validates_presence_of :name
  validates_uniqueness_of :name

  before_validation do
    self.homepage = "http://#{homepage}" unless homepage.blank? || homepage.match(/^https?:\/\//)
    self.phone.gsub!(/\s*-\s*/, "-") unless phone.blank?
    self.cell_phone.gsub!(/\s*-\s*/, "-") unless cell_phone.blank?
    self.fax.gsub!(/\s*-\s*/, "-") unless fax.blank?
    self.phone_hours.gsub!(/\s*-\s*/, "–") unless phone_hours.blank?
    self.visiting_hours.gsub!(/\s*-\s*/, "–") unless visiting_hours.blank?
  end

  def self.search(q, limit = 25, offset = 0)
    where("name like ?", "#{q}%").order(:name).limit(limit).offset(offset)
  end
end
