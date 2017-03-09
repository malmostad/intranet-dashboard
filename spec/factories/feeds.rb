# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :feed do
    feed_url { SAMPLE_FEEDS.first }
    category Feed::CATEGORIES.keys.first
  end
end
