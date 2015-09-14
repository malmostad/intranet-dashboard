# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :shortcut do
    name "Fox barx"
    url "http://www.example.com"
    category Shortcut::CATEGORIES.keys.first
  end
end
