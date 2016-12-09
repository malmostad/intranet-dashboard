# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Users" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "should have a contact card" do
    visit user_path(user.username)
    expect(page).to have_selector("h1", text: user.displayname)
    expect(page).to have_selector("h2", text: "Arbetsplats")
    expect(page).to have_selector("h2", text: "Kunskapsområden")
    expect(page).to have_selector("h2", text: "Språkkunskaper")
    expect(page).to have_selector("h2", text: "Rapporterar till")
    expect(page).to have_selector("p.email", text: 'E-postadress saknas')
  end

  it "should have an edit form for the contact card" do
    visit user_path(user.username)
    click_on "Redigera profil"
    expect(page).to have_selector("h1", text: "Redigera profil för #{user.displayname}")
    expect(page).to have_selector("#user_professional_bio")
    expect(page).to have_selector(".user_roles")
  end

  it "should have a VCard" do
    visit user_path(user.username)
    click_on "VCard"
    expect(page.status_code).to eq 200
    expect(page.html.split("\n").first).to eq "BEGIN:VCARD"
    expect(page.html.split("\n").last).to eq "END:VCARD"
  end

  it "should save edited contact card" do
    visit edit_user_path(user)
    fill_in :user_professional_bio, with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
    fill_in :user_skill_list, with: "fire fighting, PowerPoint"
    fill_in :user_language_list, with: "Swahili, Italienska"
    fill_in :user_twitter, with: "fox_barx"
    fill_in :user_linkedin, with: "https://www.linkedin.com/in/fox_barx"
    fill_in :user_private_bio, with: "Lipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt."
    click_button "Spara"
    expect(page).to have_selector(".flash.notice", text: "uppdaterades")
  end

  it "should invalidate contact card with huge professional_bio" do
    visit edit_user_path(user)
    fill_in :user_professional_bio, with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    click_button "Spara"
    expect(page).to have_selector(".warning", text: "korrigera")
  end

  it "should invalidate contact card with huge skill name" do
    visit edit_user_path(user)
    fill_in :user_skill_list, with: "Lorem, ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
    click_button "Spara"
    expect(page).to have_selector(".warning", text: "korrigera")
  end

  it "should save room number" do
    visit edit_user_path(user)
    fill_in :user_room, with: "S6094"
    click_button "Spara"
    expect(page).to have_selector(".room", text: "S6094")
  end

  it "should suggest visiting address", js: true do
    visit edit_user_path(user)
    page.execute_script "$('#user_search_address').val('Storgatan').trigger('focus').trigger('keydown')"
    item_selector = "ul.ui-autocomplete li.ui-menu-item a"
    expect(page).to have_selector(item_selector)

    page.execute_script "$('#{item_selector}').trigger('mouseenter').trigger('click')"
    page.execute_script "$('#user_search_address').blur()"

    expect(page).to have_field("Sök gatuadress:", with: "")
    expect(page).to have_field("Gatuadress:", with: "Storgatan 1A")
    expect(page).to have_field("Postnummer:", with: "211 41")
    expect(page).to have_field("Postort:", with: "Malmö")

    click_button "Spara"
    expect(page).to have_selector(".street-address", text: "Storgatan")
  end
end
