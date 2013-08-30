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
end

feature "Search results" do
  it "should have a search form" do
    visit search_path
    page.should have_selector('form#full-search')
  end

  it "should have a prefilled form" do
    query = "semester lön"
    visit "/search?#{ {q: query}.to_query}"
    find('form#full-search input[name=q]').value.should include query
  end

  it "should display a results" do
    visit "/search?#{ {q: "semester lön"}.to_query}"
    page.should have_selector('.results')
  end

  it "should have a load more link" do
    visit "/search?#{ {q: "semester"}.to_query}"
    page.should have_selector('#load-more-search-results', text: "Visa fler")
  end

  it "should load more results", js: true do
    visit "/search?#{ {q: "semester"}.to_query}"
    before = all("section.results li h2").count
    click_link("Visa fler")
    sleep 1
    before.should < all("section.results li h2").count
  end
end
