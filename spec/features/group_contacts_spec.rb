# -*- coding: utf-8 -*-
require 'spec_helper'

describe "GroupContacts" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "administration should require and administrator" do
    visit group_contacts_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  describe "administration" do
    before(:each) do
      user.update_attribute(:admin, true)
      visit group_contacts_path
    end

    it "should be available for administrators" do
      page.should have_selector('h1', text: "Funktionskontakter")
    end

    it "should create group contact" do
      click_link("Lägg till")
      fill_in "group_contact_name", with: "foo"
      click_button "Spara"
      page.should have_selector(".flash.notice", text: "skapades")
    end

    it "should update group contact" do
      create(:group_contact)
      click_button "Sök"
      first("table tbody td a").click
      click_on "Redigera"
      fill_in "group_contact_name", with: "bar"
      click_button "Spara"
      page.should have_selector(".flash.notice", text: "uppdaterades")
    end

    it "should delete group contact", js: true do
      create(:group_contact)
      click_button "Sök"
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      page.should have_selector(".flash.notice", text: "raderades")
    end
  end
end
