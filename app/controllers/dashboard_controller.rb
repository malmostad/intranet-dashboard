# -*- coding: utf-8 -*-

# Model-less controller for dashboard data from other models
class DashboardController < ApplicationController
  before_action :require_user

  COMBINED_FEED_ENTRIES_LIMIT = 20
  MAINTENANCE_FEED_ENTRIES_LIMIT = 3

  def index
    @entries_limit = COMBINED_FEED_ENTRIES_LIMIT
    @combined_entries  = FeedEntry.from_feeds(current_user.combined_feed_ids, limit: @entries_limit)

    @feature             = featured_news_entry
    @maintenance_news    = maintenance_news
    @tools_and_systems   = current_user.shortcuts.select { |s| s.category == "tools_and_systems" }
    @i_want              = current_user.shortcuts.select { |s| s.category == "i_want" }
    @colleagues          = current_user.colleagues.order("status_message_updated_at desc")
  end

  # Load more feed entries in requested category
  def more_feed_entries
    @category = params[:category]
    @entries_limit = COMBINED_FEED_ENTRIES_LIMIT
    @entries = FeedEntry.from_feeds(current_user.combined_feed_ids, { before: Time.at(params[:before].to_i), limit: COMBINED_FEED_ENTRIES_LIMIT } )
    @more_text = "Visa fler"
    render :more_feed_entries, layout: false
  end

private
  # User’s and her role’s feed entries in a given category
  def feed_entries_from_category(category, conditions = {})
    FeedEntry.from_feeds(current_user.combined_feed_ids(category), conditions)
  end

  def featured_news_entry
    Rails.cache.fetch("featured-news-entry", expires_in: 2.minute) do
      feed = Feed.where(category: "feature").first
      if feed.present?
        { entry: feed.feed_entries.order("published desc").first,
          feed_url: feed.feed_url.gsub(/\/feed\/*$/, "") }
      end
    end
  end

  def maintenance_news
    # Rails.cache.fetch("maintenance-entries", expires_in: 2.minute) do
    feeds = Feed.where(category: "maintenance_warnings")
    feed_entries = FeedEntry.from_feeds(feeds, limit: MAINTENANCE_FEED_ENTRIES_LIMIT)
    if feeds.present? && feed_entries.present?
      { entries: feed_entries,
        first_feed_url: feeds.first.feed_url.gsub(/\/feed\/*$/, "") }
    end
    # end
  end
end
