# -*- coding: utf-8 -*-

# Model-less controller for dashboard data from other models
class DashboardController < ApplicationController
  before_action :require_user

  COMBINED_FEED_ENTRIES_LIMIT = 30
  CATEGORY_FEED_ENTRIES_LIMIT = 5

  def index
    if current_user.combined_feed_stream
      @entries_limit = COMBINED_FEED_ENTRIES_LIMIT
      @combined_entries  = FeedEntry.from_feeds(current_user.combined_feed_ids, limit: @entries_limit)
    else
      @entries_limit = CATEGORY_FEED_ENTRIES_LIMIT
      @news_entries      = feed_entries_from_category("news", limit: @entries_limit)
      @dialog_entries    = feed_entries_from_category("dialog", limit: @entries_limit)
      @my_own_entries    = feed_entries_from_category("my_own", limit: @entries_limit)
    end

    @feature           = featured_news_entry
    @tools_and_systems = shortcuts_from_category("tools_and_systems")
    @i_want            = shortcuts_from_category("i_want")
    @colleagues        = current_user.colleagues.order("status_message_updated_at desc")
  end

  # Load more feed entries in requested category
  def more_feed_entries
    @category = params[:category]

    if @category == "combined"
      @entries_limit = COMBINED_FEED_ENTRIES_LIMIT
      @entries = FeedEntry.from_feeds(current_user.combined_feed_ids, { before: Time.at(params[:before].to_i), limit: COMBINED_FEED_ENTRIES_LIMIT } )
      @more_text = "Visa fler"
    else
      @entries_limit = CATEGORY_FEED_ENTRIES_LIMIT
      @entries = feed_entries_from_category(@category, { before: Time.at(params[:before].to_i), limit: CATEGORY_FEED_ENTRIES_LIMIT } )
      @more_text = "Visa fler nyheter" if @category == "news"
      @more_text = "Visa fler diskussioner" if @category == "dialog"
      @more_text = "Visa fler egna flöden" if @category == "my_own"
    end

    if @entries.present?
      render :more_feed_entries, layout: false
    else
      render :no_more_feed_entries, layout: false
    end
  end

private
  # User’s and her role’s feed entries in a given category
  def feed_entries_from_category(category, conditions = {})
    FeedEntry.from_feeds(current_user.combined_feed_ids(category), conditions)
  end

  # User’s shortcuts and her role’s shortcuts in a given category
  def shortcuts_from_category(category)
    Rails.cache.fetch("shortcuts-#{current_user.id}-#{category}", expires_in: 10.minute) do
      current_user.shortcuts_in_category(category)
    end
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
end
