# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Users" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "should have a contact card" do
    visit user_path(user.username)
    page.should have_selector("h1", text: user.displayname)
    page.should have_selector("h2", text: "Arbetsplats")
    page.should have_selector("h2", text: "Kompetens")
    page.should have_selector("h2", text: "Rapporterar till")
    page.should have_selector("p.email", text: user.email)
  end

  it "should have an edit form for the contact card" do
    visit user_path(user.username)
    click_on "Redigera profil"
    page.should have_selector("h1", text: "Redigera profil för #{user.displayname}")
    page.should have_selector("#user_professional_bio")
    page.should have_selector("#user_status_message")
    page.should have_selector(".user_roles")
  end

  it "should save edited contact card" do
    visit edit_user_path(user)
    fill_in :user_professional_bio, with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
    fill_in :user_skill_list, with: "fire fighting, PowerPoint"
    fill_in :user_language_list, with: "Swahili, Italienska"
    fill_in :user_twitter, with: "fox_barx"
    fill_in :user_private_bio, with: "Lipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt."
    click_button "Spara"
    page.should have_selector(".flash.notice", text: "uppdaterades")
  end

  it "should invalidate contact card on save" do
    visit edit_user_path(user)
    fill_in :user_professional_bio, with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    click_button "Spara"
    page.should have_selector(".alert.warning", text: "korrigera")
  end
end

