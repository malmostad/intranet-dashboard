# -*- coding: utf-8 -*-

require 'google'

# TODO: Move fetching of remote data to other actions and access with ajax

class DashboardController < ApplicationController
  before_filter { add_body_class('dashboard') }

  def index
    # Rails.cache.clear

    # Thread this so we don't have to wait for each fetching to finish before starting the next
    treads= []
    if current_user
      @username = current_user['email'].gsub(/@.+$/, '') # TODO: error checking for non existing google user
      treads << Thread.new{ @mailbox = mail }
      treads << Thread.new{ @calendar = calendar }
      treads << Thread.new{ @docs = docs }
    end
    treads << Thread.new{ @feeds = feeds }
    treads.each { |t| t.join }

    respond_to do |format|
      format.html
    end
  end

  private

  def calendar
    cache_key = Digest::MD5.hexdigest( "calendar-list-#{@username}" )
    if Rails.cache.exist?( cache_key )
      return Rails.cache.read cache_key
    end

    calendar = Google::Calendar.new(google_keys.merge(:username => @username, :api_version  =>'2.0'))
    data = calendar.list
    Rails.cache.write( cache_key , data, :expires_in => 60 * 5 )
    data
  end

  def docs
    cache_key = Digest::MD5.hexdigest( "docs-list-#{@username}" )
    if Rails.cache.exist?( cache_key )
      return Rails.cache.read cache_key
    end

    docs = Google::Docs.new(google_keys.merge(:username => @username, :api_version  =>'3.0'))
    data = docs.list
    Rails.cache.write( cache_key , data, :expires_in => 60 * 5 )
    data
  end

  def mail
    box = 'INBOX'
    cache_key = Digest::MD5.hexdigest( "mail-#{box}-#{@username}" )
    if Rails.cache.exist?( cache_key )
      return Rails.cache.read cache_key
    end

    gmail = Google::Mail.new( google_keys.merge(:username => @username) )
    data = gmail.read_box(:box => box)
    Rails.cache.write( cache_key , data, :expires_in => 60 * 5 )
    data
  end

  def feeds
    reader = FeedReader.new
    feeds = Array.new
    Feed.all.each do |feed|
      cache_key = Digest::MD5.hexdigest( "feed-#{feed.url}" )

      if Rails.cache.exist?( cache_key )
       feeds << Rails.cache.read( cache_key )
      else
        data = reader.consume(feed.name, feed.url)
        Rails.cache.write( cache_key , data, :expires_in => 60 * 30 )
        feeds << data
      end
    end
    feeds
  end
end
