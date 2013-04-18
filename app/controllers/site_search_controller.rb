# -*- coding: utf-8 -*-
require 'open-uri'

class SiteSearchController < ApplicationController
  before_filter { add_body_class "site-search" }

  def index
    @terms = params[:q]
    if @terms.present?
      @results = SiteSearch::Search.new(params.except(:action, :controller).to_query, APP_CONFIG['site_search_query_url'])
    end

    if request.xhr?
      render :more, layout: false
    else
      render :index
    end
  end

  def autocomplete
    begin
      results = open("#{APP_CONFIG['site_search_autocomplete_url']}?q=#{params[:q]}&ilang=sv&callback=results", read_timeout: 5).first
    rescue Exception => e
      results = 'results({})'
    end
    render json: results
  end
end
