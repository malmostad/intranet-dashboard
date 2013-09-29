# -*- coding: utf-8 -*-
require 'spec_helper'
require 'nokogiri'

describe SiteSearch do
  describe "results" do

    before(:each) do
      terms = { q: "semester" }
      @results = SiteSearch::Search.new(terms.to_query)
    end

    it "should have sorting" do
      @results.sorting.should be_present
    end

    it "should have a first sorting entry with text" do
      @results.sorting.first.text.should be_present
    end

    it "should have a second sorting entry with an url" do
      @results.sorting[1].query.should be_present
    end

    it "should not have an error message" do
      @results.error.should be nil
    end

    it "should have a number of hits" do
      @results.total.class.should be Fixnum
    end

    it "should have results" do
      @results.entries.count.should > 0
    end

    describe "result entry" do
      it "should have an order number" do
        @results.entries.first.number.should eq 1
      end

      it "should have a title" do
        @results.entries.first.title.class.should be String
      end

      it "should have an extract" do
        @results.entries.first.summary.should be_present
      end

      it "should have a breadcrumb" do
        @results.entries.first.breadcrumbs.class.should be_present
      end

      it "should have a category" do
        @results.entries.first.category.class.should be String
      end

      it "should have a date string" do
        @results.entries.first.date.should be_present
      end
    end

    it "should have a query string for getting more results" do
      @results.more_query.should be_present
    end

    it "should have a categories" do
      @results.category_groups.class.should be Array
    end

    it "should show a spelling suggestions" do
      results = SiteSearch::Search.new({ q: "semstr" }.to_query)
      results.suggestions.count.should > 0
    end
  end
end
