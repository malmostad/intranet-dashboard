# -*- coding: utf-8 -*-
require 'spec_helper'

describe Feed do
  it "should be valid" do
    expect(build(:feed)).to be_valid
  end

  it "should be invalid" do
    expect(build(:feed, feed_url: "www.example.com")).to be_invalid
  end

  it "should be invalid" do
    expect(build(:feed, feed_url: "http://www.example.com")).to be_invalid
  end

  it "should strip pseudo protocol" do
    expect(build(:feed, feed_url: "feed://www.whitehouse.gov/feed/press")).to be_valid
  end

  it "should be valid" do
    expect(build(:feed, feed_url: "www.whitehouse.gov/feed/press")).to be_valid
  end

  it "should not be valid without a feed_url" do
    expect(build(:feed, feed_url: "")).not_to be_valid
  end

  it "should be created" do
    expect { create(:feed) }.to change(Feed, :count).by(1)
  end

  it "should have a title" do
    expect(build(:feed)).to respond_to :title
  end

  describe "creation" do
    let(:feed) { create(:feed) }
    it "should have a title" do
      expect(feed.title).to be_present
    end

    it "should have a feed_url" do
      expect(feed.feed_url).to be_present
    end

    it "should have a feed_url" do
      expect(feed.feed_url).to be_present
    end

    it "should have an url" do
      expect(feed.url).to be_present
    end

    it "should have feed entries" do
      expect { create(:feed) }.to change(FeedEntry, :count).by_at_least(10)
    end

    it "should have a valid category" do
      expect(Feed::CATEGORIES).to have_key(feed.category)
    end

    it "should have feed_entries after clear and reload feed" do
      f = Feed.find(feed.id) # feed.reload do not work here
      f.refresh_entries
      expect(f.feed_entries.count).to be > 0
    end

    it "should change updated_at on clear and reload feed" do
      updated_at = feed.updated_at
      feed.refresh_entries
      expect(feed.updated_at).to be > updated_at
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
