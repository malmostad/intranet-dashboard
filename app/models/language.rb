# -*- coding: utf-8 -*-
class Language < ActiveRecord::Base
  attr_accessible :name
  has_many :user_languages
  has_many :users, through: :user_languages

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett språk med det namnet." },
    length: { maximum: 48 }

  before_save do
    self.name.downcase!
  end

  # Merge first language into second. Transfer users having first to second.
  def merge(into)
    if into && into.update_attribute(:users, (users + into.users).uniq)
      destroy
    else
      self.errors.add(:into, "Du måste välja ett språk från listan")
      false
    end
  end
end
