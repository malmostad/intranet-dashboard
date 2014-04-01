# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :feed do
    feed_url { "file://#{Rails.root.join('spec', 'samples', 'feeds', 'TechCrunch.xml')}" }
    category Feed::CATEGORIES.keys.first
  end
end
