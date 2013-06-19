# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Feeds" do
  before(:each) do
    create_named_user_with_roles_with_feeds
    login_named_user
  end

  scenario "should have news feed entries box" do
    page.should have_selector('h1', text: "Mina Kominnyheter")
  end

  scenario "should have news feed entries" do
    all("#feeds-news .box-content li").count.should > 1
  end

  scenario "should have news feed entries" do
    all("#feeds-news .box-content li").count.should > 1
  end

  scenario "should have dialog feed entries" do
    all("#feeds-dialog .box-content li").count.should > 1
  end

  scenario "should have one feture feed entry" do
    all("#feeds-feature .box-content li").count.should == 1
  end

  scenario "should load more news feed entries", :js => true do
    before = all("#feeds-news .box-content li").count
    find("#feeds-news .box-content li.load-more input").click
    sleep 1
    before.should < all("#feeds-news .box-content li").count
  end

  context "editing" do
    scenario "should be protected for regular users" do
      visit skills_path
      page.should have_selector('.error', text: "Du saknar behörighet")
    end
  end
end
