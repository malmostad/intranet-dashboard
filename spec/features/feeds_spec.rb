# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Feeds" do
  let(:user) { create(:user) }
  before(:each) do
    create_feeds_for_user(user)
    login(user.username, "") # Stubbed auth
  end

  it "should have news feed entries box" do
    page.should have_selector('h1', text: "Mina Kominnyheter")
  end

  it "should have news feed entries" do
    all("#feeds-news .box-content li").count.should > 1
  end

  it "should have dialog feed entries" do
    all("#feeds-dialog .box-content li").count.should > 1
  end

  it "should have one feature feed entry" do
    all("#feeds-feature .box-content li").count.should == 1
  end

  it "should load more news feed entries", :js => true do
    before = all("#feeds-news .box-content li").count
    find("#feeds-news .box-content li.load-more input").value.should == "Visa fler"
    find("#feeds-news .box-content li.load-more input").click
    find("#feeds-news .box-content li.load-more input").value.should == "Hämtar fler..."

    sleep 1
    before.should < all("#feeds-news .box-content li").count
  end

  it "administration should require and administrator" do
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  describe "administration" do
    before(:each) do
      user.update_attribute(:admin, true)
      visit feeds_path
    end

    it "should be available for administrators" do
      page.should have_selector('h1', text: "Nyhetsflöden")
    end

    it "should create feed" do
      click_link("Lägg till")
      fill_in "feed_feed_url", with: "https://github.com/jnicklas/capybara/commits/master.atom"
      click_button "Spara"
      page.should have_selector(".flash.notice", text: "skapades")
    end

    it "should update feed" do
      first("table tbody td a").click
      fill_in "feed_feed_url", with: "https://github.com/ariya/phantomjs/commits/master.atom"
      click_button "Spara"
      page.should have_selector(".flash.notice", text: "uppdaterades")
    end

    it "should delete feed", js: true do
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      page.should have_selector(".flash.notice", text: "raderades")
    end

    it "should refresh feed", js: true do
      first("table tbody td a").click
      click_on "Radera alla nyheter i flödet"
      page.evaluate_script("window.confirm()")
      page.should have_selector(".flash.notice", text: "De senaste nyheterna hämtades från källan")
    end
  end
end
