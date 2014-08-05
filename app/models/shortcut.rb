# -*- coding: utf-8 -*-
require 'digest/sha1'

# Shortcut links like "Verktyg & system"
class Shortcut < ActiveRecord::Base

  CATEGORIES = {
    "tools_and_systems" => "Verktyg & system",
    "i_want" => "Jag vill"
  }

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users
  default_scope { order("name ASC") }

  attr_accessible :name, :url, :category, :role_ids

  validates :name,  :url,
      presence: { is: true, message: "Namnet måste fyllas i." }
  validates :url,
      format: { with: /\Ahttps?:\/\//, message: "URL:en måste starta med http:// eller https://." },
      length: { minimum: 11, message: "URL:en är inte korrekt." }

  before_validation do
    self.url = "http://#{url}" unless url.match(/\Ahttps?:\/\//)
  end
end
