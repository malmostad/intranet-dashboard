# -*- coding: utf-8 -*-
require 'spec_helper'
require 'nokogiri'

describe SiteSeeker do
  describe "results" do

    before(:each) do
      query = { q: "semester" }
      @site_seeker = SiteSeeker.new
      @results = @site_seeker.search(query, "/foo/?")
    end

    it "should be a Hash" do
      @results.class.should eq Hash
    end

    it "should have a Hash for sorting" do
      @results[:sorting].class.should be Array
    end

    it "should have a first sorting entry with text" do
      @results[:sorting][0][:text].should_not be_nil
    end

    it "should have a second sorting entry with an url" do
      @results[:sorting][1][:query].should_not be_nil
    end

    it "should not have an error message" do
      @results[:error].should be nil
    end

    it "should have a number of hits" do
      @results[:count].class.should be String
    end

    it "should have results" do
      @results[:entries].count.should > 0
    end

    describe "result entry" do
      it "should have an order number" do
        @results[:entries].first[:number].should eq 1
      end

      it "should have a title" do
        @results[:entries].first[:title].class.should be Nokogiri::XML::NodeSet
      end

      it "should have an extract" do
        @results[:entries].first[:extract].should_not be_nil
      end

      it "should have a breadcrumb" do
        @results[:entries].first[:breadcrumb].class.should be Nokogiri::XML::NodeSet
      end

      it "should have a category" do
        @results[:entries].first[:extract].class.should be String
      end

      it "should have a date string" do
        @results[:entries].first[:date].class.should be String
      end
    end

    it "should have a paging array" do
      @results[:paging].class.should be Array
    end

    it "should have a query string for getting more results" do
      @results[:more_query].class.should_not be_nil
    end

    it "should have a categories NodeSet" do
      @results[:categories].class.should be Nokogiri::XML::NodeSet
    end

    it "should show a spelling suggestions" do
      results = @site_seeker.search({ q: "semstr" }, "/foo/?")
      results[:suggestions].count.should > 1
    end
  end
end
