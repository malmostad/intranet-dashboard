# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :feed do
    feed_url { "http://feeds.feedburner.com/Techcrunch" }
    category Feed::CATEGORIES.keys.first
  end
end
