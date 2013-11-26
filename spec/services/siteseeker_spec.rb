# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SiteseekerNormalizer" do
  before(:each) do
    @client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], APP_CONFIG['siteseeker']['index'], encoding: "UTF-8")
    @response = @client.search("barn")
  end

  it "should have a number of hits" do
    @response.total.should be_a Fixnum
  end

  it "should have results" do
    @response.entries.count.should > 0
  end

  describe "result entry" do
    it "should have an order number" do
      @response.entries.first.number.should eq 1
    end

    it "should have a title" do
      @response.entries.first.title.should be_a String
    end

    it "should have an extract" do
      @response.entries.first.summary.should be_a String
    end

    it "should have a breadcrumb" do
      @response.entries.first.breadcrumbs.should be_an Array
    end

    it "should have a category" do
      @response.entries.first.category.should be_a String
    end

    it "should have a date string" do
      @response.entries.first.date.should be_a String
    end
  end

  it "should have sorting" do
    @response.sorting.should be_an Array
  end

  it "should have a first sorting entry with text" do
    @response.sorting.first.text.should be_a String
  end

  it "should have a second sorting entry with an url" do
    @response.sorting[1].query.should be_a String
  end

  it "should have a query string for getting more results" do
    @response.more_query.should be_a String
  end

  it "should have a categories" do
    @response.category_groups.should be_an Array
  end

  it "should also take an array as a search argument" do
    response = @client.search({q: "barn"})
    response.total.should > 0
  end

  it "should show a spelling suggestions" do
    response = @client.search("barnomsrg")
    response.suggestions.count.should > 0
  end

  it "should raise an error for an invalid search url" do
    expect {
      client = SiteseekerNormalizer::Client.new("x")
      response = client.search("y")
    }.to raise_error
  end

  it "should raise an error for an invalid account name" do
    expect {
      client = SiteseekerNormalizer::Client.new("x", APP_CONFIG['siteseeker']["index"])
      response = client.search("y")
    }.to raise_error(SocketError)
  end

  it "should raise an error for an invalid index name" do
    expect {
      client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], "foo")
      response = client.search("y")
    }.to raise_error(OpenURI::HTTPError)
  end

  it "should raise a timeout error" do
    expect {
      client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], APP_CONFIG['siteseeker']["index"], read_timeout: 0.01)
      response = client.search("y")
    }.to raise_error(Timeout::Error)
  end
end
