# -*- coding: utf-8 -*-
class Activity < ActiveRecord::Base
  attr_accessible :name
  has_many :user_activities
  has_many :users, through: :user_activities

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett aktivitet med det namnet." },
    length: { maximum: 48 }

  # Merge first activity into second. Transfer users having first to second.
  def merge(into)
    if into && into.id == id
      self.errors.add(:into, "Du kan inte slå samman en aktivitet med sig själv!")
      return false
    end

    if into && into.update_attribute(:users, (users + into.users).uniq)
      destroy
    else
      self.errors.add(:into, "Du måste välja ett aktivitet från listan")
      false
    end
  end
end
