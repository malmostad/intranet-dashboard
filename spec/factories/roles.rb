# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "Role-#{n}" }
    homepage_url 'http://rspec.info/'
    category Role::CATEGORIES.keys.first
  end
end

