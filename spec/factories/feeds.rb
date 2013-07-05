# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :feed do
    feed_url "https://github.com/rspec/rspec/commits.atom"
    category Feed::CATEGORIES.keys.first
  end
end
