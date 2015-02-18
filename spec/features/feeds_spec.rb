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
    expect(page).to have_selector('h1', text: "Nyheter")
  end

  it "should have news feed entries" do
    expect(all("section.news .box-content li").count).to be > 1
  end

  it "should have dialog feed entries" do
    expect(all("section.dialog .box-content li").count).to be > 1
  end

  it "should have one feature feed entry" do
    expect(all("#feeds-feature .box-content li").count).to eq 1
  end

  it "should load more news feed entries", js: true do
    before = all("section.news .box-content li").count
    expect(find("section.news .box-content li.load-more button").text).to eq "Visa fler nyheter"
    find("section.news .box-content li.load-more button").click
    expect(find("section.news .box-content li.load-more button").text).to eq "Hämtar fler..."
    sleep 1
    expect(before).to be < all("section.news .box-content li").count
  end

  it "should switch to combined news and back again", js: true do
    first(".box.feeds .dropdown button").click
    click_link("Visa sammanslaget")
    expect(page).to_not have_selector('section.news h1', text: "Nyheter")
    expect(@user.reload.combined_feed_stream?).to eq true
    first(".box.feeds .dropdown button").click
    click_link("Visa kategoriserat")
    expect(page).to have_selector('section.news h1', text: "Nyheter")
    expect(@user.reload.combined_feed_stream?).to be false
  end

  it "should lazy load more combined news feed entries", js: true do
    first(".box.feeds .dropdown button").click
    click_link("Visa sammanslaget")
    before = all(".combined .box-content li").count
    expect(find("li.load-more button").text).to eq "Visa fler"
    page.execute_script("window.scrollTo(0, 10000)")
    expect(find(".box-content li.load-more button").text).to eq "Hämtar fler..."
    sleep 0.2
    expect(before).to be < all(".combined .box-content li").count
  end

  it "administration should require and administrator" do
    visit feeds_path
    expect(page).to have_selector('.error', text: "Du saknar behörighet")
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
      expect(page).to have_selector('h1', text: "Nyhetsflöden")
    end

    it "should create feed" do
      click_link("Lägg till")
      fill_in "feed_feed_url", with: "https://github.com/jnicklas/capybara/commits/master.atom"
      click_button "Spara"
      expect(page).to have_selector(".flash.notice", text: "skapades")
    end

    it "should update feed" do
      first("table tbody td a").click
      fill_in "feed_feed_url", with: "https://github.com/ariya/phantomjs/commits/master.atom"
      click_button "Spara"
      expect(page).to have_selector(".flash.notice", text: "uppdaterades")
    end

    it "should delete feed", js: true do
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      expect(page).to have_selector(".flash.notice", text: "raderades")
    end

    it "should refresh feed", js: true do
      first("table tbody td a").click
      click_on "Radera alla nyheter i flödet"
      page.evaluate_script("window.confirm()")
      expect(page).to have_selector(".flash.notice", text: "De senaste nyheterna hämtades från källan")
    end
  end
end
