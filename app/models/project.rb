# -*- coding: utf-8 -*-
class Project < ActiveRecord::Base
  attr_accessible :name
  has_many :user_projects
  has_many :users, through: :user_projects

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett projekt med det namnet." },
    length: { maximum: 48 }

  # Merge first project into second. Transfer users having first to second.
  def merge(into)
    if into && into.id == id
      self.errors.add(:into, "Du kan inte slå samman ett projekt med sig själv!")
      return false
    end

    if into && into.update_attribute(:users, (users + into.users).uniq)
      destroy
    else
      self.errors.add(:into, "Du måste välja ett projekt från listan")
      false
    end
  end
end
