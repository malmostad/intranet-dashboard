# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "Role-#{n}-#{Kernel.rand(1..2**100)}" }
    homepage_url 'http://rspec.info/'
    category Role::CATEGORIES.keys[Kernel.rand(1..2) % Role::CATEGORIES.size]
  end
end

