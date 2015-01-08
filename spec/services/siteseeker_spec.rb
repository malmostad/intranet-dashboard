# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SiteseekerNormalizer" do
  before(:each) do
    @client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], APP_CONFIG['siteseeker']['index'], encoding: "UTF-8")
    @response = @client.search("barn")
  end

  it "should have a number of hits" do
    expect(@response.total).to be_a Fixnum
  end

  it "should have results" do
    expect(@response.entries.count).to be > 0
  end

  describe "result entry" do
    it "should have an order number" do
      expect(@response.entries.first.number).to eq 1
    end

    it "should have a title" do
      expect(@response.entries.first.title).to be_a String
    end

    it "should have an extract" do
      expect(@response.entries.first.summary).to be_a String
    end

    it "should have a breadcrumb" do
      expect(@response.entries.first.breadcrumbs).to be_an Array
    end

    it "should have a category" do
      expect(@response.entries.first.category).to be_a String
    end

    it "should have a date string" do
      expect(@response.entries.first.date).to be_a String
    end
  end

  it "should have sorting" do
    expect(@response.sorting).to be_an Array
  end

  it "should have a first sorting entry with text" do
    expect(@response.sorting.first.text).to be_a String
  end

  it "should have a second sorting entry with an url" do
    expect(@response.sorting[1].query).to be_a String
  end

  it "should have a query string for getting more results" do
    expect(@response.more_query).to be_a String
  end

  it "should have a categories" do
    expect(@response.category_groups).to be_an Array
  end

  it "should also take an array as a search argument" do
    response = @client.search({q: "barn"})
    expect(response.total).to be > 0
  end

  it "should show a spelling suggestions" do
    response = @client.search("barnomsrg")
    expect(response.suggestions.count).to be > 0
  end

  it "should raise an error for an invalid search url" do
    expect {
      client = SiteseekerNormalizer::Client.new("x")
      client.search("y")
    }.to raise_error
  end

  it "should raise an error for an invalid account name" do
    expect {
      client = SiteseekerNormalizer::Client.new("x", APP_CONFIG['siteseeker']["index"])
      client.search("y")
    }.to raise_error(SocketError)
  end

  it "should raise an error for an invalid index name" do
    expect {
      client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], "foo")
      client.search("y")
    }.to raise_error(OpenURI::HTTPError)
  end

  it "should raise a timeout error" do
    expect {
      client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], APP_CONFIG['siteseeker']["index"], read_timeout: 0.01)
      client.search("y")
    }.to raise_error(Timeout::Error)
  end
end
