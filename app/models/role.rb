# -*- coding: utf-8 -*-

# Roles are assigned to users and to information objects like feeds and shortcuts
class Role < ActiveRecord::Base

  CATEGORIES = {
    "department" => "Förvaltning",
    "working_field" => "Arbetsfält"
  }

  has_and_belongs_to_many :users
  has_and_belongs_to_many :shortcuts
  has_and_belongs_to_many :feeds

  attr_accessible :name, :category, :homepage_url

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan en roll med det namnet." }
  validates :homepage_url,
    presence: { is: true, message: "URL till hemsida måste anges" }
  validates :category,
    presence: { is: true, message: "Du måste välja en kategori." }


  def self.roles_by_feeds_categories(feed_category)
    where(feeds.category => feed_category)
  end
end