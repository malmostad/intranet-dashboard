# -*- coding: utf-8 -*-
class Skill < ActiveRecord::Base
  attr_accessible :name
  has_many :user_skills
  has_many :users, through: :user_skills

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett kunskapsområde med det namnet." },
    length: { maximum: 48 }

  # Merge first skill into second. Transfer users having first to second.
  def merge(into)
    if into && into.id == id
      self.errors.add(:into, "Du kan inte slå samman ett kunskapsområde med sig själv!")
      return false
    end

    if into && into.update_attribute(:users, (users + into.users).uniq)
      destroy
    else
      self.errors.add(:into, "Du måste välja ett kunskapsområde från listan")
      false
    end
  end
end
