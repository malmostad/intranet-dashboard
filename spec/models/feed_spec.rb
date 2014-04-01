# -*- coding: utf-8 -*-
require 'spec_helper'

describe Feed do
  it "should be valid" do
    build(:feed).should be_valid
  end

  it "should be invalid" do
    build(:feed, feed_url: "www.example.com").should be_invalid
  end

  it "should be invalid" do
    build(:feed, feed_url: "http://www.example.com").should be_invalid
  end

  it "should be valid" do
    build(:feed, feed_url: "feed://www.whitehouse.gov/feed/press").should be_valid
  end

  it "should be valid" do
    build(:feed, feed_url: "www.whitehouse.gov/feed/press").should be_valid
  end

  it "should not be valid without a feed_url" do
    build(:feed, feed_url: "").should_not be_valid
  end

  it "should be created" do
    expect { create(:feed) }.to change(Feed, :count).by(1)
  end

  it "should have a title" do
    build(:feed).should respond_to :title
  end

  describe "creation" do
    let(:feed) { create(:feed) }
    it "should have a title" do
      feed.title.should be_present
    end

    it "should have a feed_url" do
      feed.feed_url.should be_present
    end

    it "should have a feed_url" do
      feed.feed_url.should be_present
    end

    it "should have an url" do
      feed.url.should be_present
    end

    it "should have feed entries" do
      expect { create(:feed) }.to change(FeedEntry, :count).by_at_least(10)
    end

    it "should have a valid category" do
      Feed::CATEGORIES.should have_key(feed.category)
    end

    it "should have feed_entries after clear and reload feed" do
      feed.refresh_entries
      feed.feed_entries.count.should > 0
    end

    it "should change updated_at on clear and reload feed" do
      updated_at = feed.updated_at
      feed.refresh_entries
      feed.updated_at.should > updated_at
    end
  end

  describe "destruction" do
    it "should be destroyed" do
      feed = create(:feed)
      expect { feed.destroy }.to change(Feed, :count).by(-1)
    end

    it "should destroy associated feed_entries" do
      feed = create(:feed)
      items = feed.feed_entries.size
      expect { feed.destroy }.to change(FeedEntry, :count).by(-items)
    end
  end
end
