# -*- coding: utf-8 -*-
class Responsibility < ActiveRecord::Base
  attr_accessible :name

  has_many :user_responsibilities
  has_many :users, through: :user_responsibilities

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett ansvarsområde med det namnet." }
end
