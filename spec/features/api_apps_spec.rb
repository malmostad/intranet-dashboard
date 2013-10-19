# -*- coding: utf-8 -*-
require 'spec_helper'

describe "ApiApps" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "administration should require and administrator" do
    visit api_apps_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  describe "administration" do
    before(:each) do
      user.update_attribute(:admin, true)
      visit api_apps_path
    end

    it "should be available for administrators" do
      page.should have_selector('h1', text: "API-applikationer")
    end

    it "should require an api app name" do
      click_link("Lägg till")
      fill_in "api_app_name", with: ""
      fill_in "api_app_contact", with: "foo"
      fill_in "api_app_ip_address", with: "127.0.0.1"
      click_button "Spara"
      page.should have_selector(".warning", text: "Vänligen korrigera")
    end

    it "should create api app" do
      click_link("Lägg till")
      fill_in "api_app_name", with: "foo"
      fill_in "api_app_contact", with: "foo"
      fill_in "api_app_ip_address", with: "127.0.0.1"
      click_button "Spara"
      page.should have_selector(".flash.notice", text: "sparades")
      page.should have_selector(".warning", text: "Kopiera app_secret")
    end

    it "should update api app" do
      create(:api_app)
      visit api_apps_path
      first("table tbody td a").click
      click_on "Redigera"
      fill_in "api_app_name", with: "bar"
      click_button "Spara"
      page.should have_selector(".flash.notice", text: "uppdaterades")
    end

    it "should delete api app", js: true do
      create(:api_app)
      visit api_apps_path
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      page.should have_selector(".flash.notice", text: "raderades")
    end
  end
end
