# -*- coding: utf-8 -*-

# Users own feeds, not avaiable to anybody else
# Those feeds are stored as regular Feed objects with the "my_own" category
class MyOwnFeedsController < ApplicationController
  before_filter { add_body_class('edit feeds') }
  before_filter :require_user, :clear_feed_entries_cache

  def index
    @feeds = Feed.joins(:users).where(category: "my_own", users: { id: current_user.id } )
  end

  def new
    @feed = Feed.new
  end

  def edit
    # Get feed and secure that it is the users own feed
    @feed = Feed.joins(:users).where(id: params[:id], category: "my_own", users: { id: current_user.id } ).first
  end

  def create
    @feed = Feed.new(params[:feed])

    # Glue feed to the user
    @feed.category = "my_own"
    @feed.user_ids = current_user.id

    if @feed.save
      redirect_to my_own_feeds_path, notice: "Ditt nyhetsflöde skapades"
    else
      render action: "new"
    end
  end

  def update
    # Check that it is the users own feed
    safe_id = Feed.joins(:users).where(id: params[:id], category: "my_own", users: { id: current_user.id } ).first.id
    @feed = Feed.find(safe_id)

    # Glue feed params to user
    @feed.category = "my_own"
    @feed.user_ids = current_user.id

    if @feed.update_attributes(params[:feed])
      redirect_to my_own_feeds_path, notice: "Ditt nyhetsflöde uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    # Check that it is the users own feed
    @feed = Feed.joins(:users).where(id: params[:id], category: "my_own", users: { id: current_user.id } ).first
    if @feed.destroy
      redirect_to my_own_feeds_path, notice: "Ditt nyhetsflöde raderades"
    else
      redirect_to my_own_feeds_path, warning: "Nyhetsflödet kunde inte raderas"
    end
  end

  def destroy_all
    # Destroy all the users own feeds
    @feeds = Feed.joins(:users).where(category: "my_own", users: { id: current_user.id } )
    if @feeds.destroy_all
      redirect_to root_path, notice: "Alla Mina flöden raderades"
    else
      redirect_to my_own_feeds_path, warning: "Nyhetsflödena kunde inte raderas"
    end
  end

  private

  # Clear the users key/value ttl cache for feed entries
  def clear_feed_entries_cache
    Rails.cache.delete("feed_entries-#{current_user.id}-my_own")
  end
end
