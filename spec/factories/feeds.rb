# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :feed do
    feed_url "http://www.whitehouse.gov/feed/press"
    category Feed::CATEGORIES.keys.first
  end
end

