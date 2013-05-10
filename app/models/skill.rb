# -*- coding: utf-8 -*-
class Skill < ActiveRecord::Base
  attr_accessible :name
  has_many :user_skills
  has_many :users, through: :user_skills

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett kunskapsområde med det namnet." }

  before_save do
    self.name.downcase!
  end
end
