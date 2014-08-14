# -*- coding: utf-8 -*-

# Model-less controller for dashboard data from other models
class DashboardController < ApplicationController
  before_action :require_user

  def index
    @limit = 5
    @feature_entry     = cache_users_entries_for("feature").first
    @feature_feed_url  = Feed.where(category: "feature").first

    @news_entries      = cache_users_entries_for("news")
    @dialog_entries    = cache_users_entries_for("dialog")
    @my_own_entries    = cache_users_entries_for("my_own")

    @tools_and_systems = cache_users_shortcuts_for("tools_and_systems")
    @i_want            = cache_users_shortcuts_for("i_want")

    @colleagueships    = current_user.sorted_colleagues
  end

  # Load more feed entries in requested category
  def more_feed_entries
    @limit = 10
    @category = params[:category]
    @entries = more_of_same(@category, Time.at(params[:before].to_i), @limit)
    if @entries.present?
      render :more_feed_entries, layout: false
    else
      render :no_more_feed_entries, layout: false
    end
  end

  private

  # TODO: give real name to def and cache query
  def more_of_same(category, before, limit)
    FeedEntry.from_feeds(current_user.combined_feed_ids(category), before: before, limit: limit)
  end

  # Cache the user’s and her role’s feed entries in a given category
  def cache_users_entries_for(category)
    Rails.cache.fetch("feed_entries-#{current_user.id}-#{category}", expires_in: 1.minute) do
      FeedEntry.from_feeds current_user.combined_feed_ids(category)
    end
  end

  # Cache the user’s shortcuts and her role’s shortcuts in a given category
  def cache_users_shortcuts_for(category)
    Rails.cache.fetch("shortcuts-#{current_user.id}-#{category}", expires_in: 10.minute) do
      current_user.shortcuts_in_category(category)
    end
  end
end
