# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SiteSearch" do
  it "should not require login" do
    visit search_path
    current_path.should eq(search_path)
  end

  it "should have a search form" do
    visit search_path
    page.should have_selector('form#full-search')
  end

  describe "results" do
    before(:each) do
      @query = "semester lön"
      visit "/search?#{ {q: @query}.to_query}"
    end

    it "should have a prefilled form" do
      find("form#full-search input[name=q]").value.should include @query
    end

    it "should have a summary" do
      page.should have_selector(".summary", text: "Din sökning gav")
    end

    it "should have a sort menu" do
      page.should have_selector("menu.sort", text: "relevans")
    end

    it "should have categories" do
      page.should have_selector(".categories")
    end

    it "should have hits for the main category in parenthesis" do
      find(".categories .current .hits").text.should match(/\(\d+\)/)
    end

    it "should have results" do
      page.should have_selector(".results")
    end

    it "should have results with linked headings" do
      page.should have_selector(".results > ul > li:first-child  h2 a")
    end

    it "should have a results entry with extracts" do
      page.should have_selector(".results > ul > li:first-child .extract")
    end

    it "should have a results entry with a category" do
      page.should have_selector(".results > ul > li:first-child .category")
    end

    it "should have a results entry a breadcrumb" do
      page.should have_selector(".results .breadcrumbs li")
    end

    it "should have a load more link" do
      page.should have_selector("#load-more-search-results", text: "Visa fler")
    end

    it "should load more results", js: true do
      before = all("section.results li h2").count
      click_on("Visa fler")
      sleep 3
      before.should < all("section.results li h2").count
    end
  end
end
