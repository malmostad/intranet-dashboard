# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SiteSearch" do
  it "should not require login" do
    visit search_path
    expect(current_path).to eq(search_path)
  end

  it "should have a search form" do
    visit search_path
    expect(page).to have_selector('form#full-search')
  end

  describe "results" do
    before(:each) do
      @query = "semester lön"
      visit "/search?#{ {q: @query}.to_query}"
    end

    it "should have a prefilled form" do
      expect(find("form#full-search input[name=q]").value).to include @query
    end

    it "should have a summary" do
      expect(page).to have_selector(".summary", text: "Din sökning gav")
    end

    it "should have a sort menu" do
      expect(page).to have_selector("menu.sort", text: "relevans")
    end

    it "should have categories" do
      expect(page).to have_selector(".categories")
    end

    it "should have hits for the main category in parenthesis" do
      expect(find(".categories .current .hits").text).to match(/\(\d+\)/)
    end

    it "should have results" do
      expect(page).to have_selector(".results")
    end

    it "should have results with linked headings" do
      expect(page).to have_selector(".results > ul > li:first-child  h2 a")
    end

    it "should have a results entry with extracts" do
      expect(page).to have_selector(".results > ul > li:first-child .extract")
    end

    it "should have a results entry with a category" do
      expect(page).to have_selector(".results > ul > li:first-child .category")
    end

    it "should have a results entry a breadcrumb" do
      expect(page).to have_selector(".results .breadcrumbs li")
    end

    it "should have a load more link" do
      expect(page).to have_selector("#load-more-search-results", text: "Visa fler")
    end

    it "should load more results", js: true do
      before = all("section.results li h2").count
      click_on("Visa fler")
      sleep 3
      expect(before).to be < all("section.results li h2").count
    end
  end
end
