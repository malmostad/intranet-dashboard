# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Feeds" do
  before(:all) do
    @user = create(:user)
    create_feeds_for_user(@user)
  end

  before(:each) do
    login(@user.username, "") # Stubbed auth
  end

  it "should have news feed entries box" do
    page.should have_selector('h1', text: "Nyheter")
  end

  it "should have news feed entries" do
    all("section.news .box-content li").count.should > 1
  end

  it "should have dialog feed entries" do
    all("section.dialog .box-content li").count.should > 1
  end

  it "should have one feature feed entry" do
    all("#feeds-feature .box-content li").count.should == 1
  end

  it "should load more news feed entries", js: true do
    before = all("section.news .box-content li").count
    find("section.news .box-content li.load-more input").value.should == "Visa fler nyheter"
    find("section.news .box-content li.load-more input").click
    find("section.news .box-content li.load-more input").value.should == "Hämtar fler..."
    before.should < all("section.news .box-content li").count
  end

  it "should switch to combined news and back again", js: true do
    first(".box.feeds .dropdown").click
    click_link("Visa sammanslaget")
    page.should_not have_selector('section.news h1', text: "Nyheter")
    @user.reload.combined_feed_stream?.should == true
    first(".box.feeds .dropdown").click
    click_link("Visa kategoriserat")
    page.should have_selector('section.news h1', text: "Nyheter")
    @user.reload.combined_feed_stream?.should == false
  end

  it "should lazy load more combined news feed entries", js: true do
    first(".box.feeds .dropdown").click
    click_link("Visa sammanslaget")
    before = all(".combined .box-content li").count
    find("li.load-more input").value.should == "Visa fler"
    page.execute_script("window.scrollTo(0, 10000)")
    find(".box-content li.load-more input").value.should == "Hämtar fler..."
    before.should < all(".combined .box-content li").count
  end

  it "administration should require and administrator" do
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  describe "administration" do
    before(:all) do
      @user.update_attribute(:admin, true)
    end

    before(:each) do
      login(@user.username, "") # Stubbed auth
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
