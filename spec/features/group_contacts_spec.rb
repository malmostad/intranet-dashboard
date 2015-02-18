# -*- coding: utf-8 -*-
require 'spec_helper'

describe "GroupContacts" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "administration should require a contacts_editor" do
    visit group_contacts_path
    expect(page).to have_selector('.error', text: "Du saknar behörighet")
  end

  describe "editing" do
    before(:each) do
      user.update_attribute(:contacts_editor, true)
      visit group_contacts_path
    end

    it "should be available for contacts_editor" do
      expect(page).to have_selector('h1', text: "Funktionskontakter")
    end

    it "should create group contact" do
      click_link("Lägg till")
      fill_in "group_contact_name", with: "foo"
      click_button "Spara"
      expect(page).to have_selector(".flash.notice", text: "skapades")
    end

    it "should update group contact" do
      create(:group_contact)
      click_button "Sök"
      first("table tbody td a").click
      click_on "Redigera"
      fill_in "group_contact_name", with: "bar"
      click_button "Spara"
      expect(page).to have_selector(".flash.notice", text: "uppdaterades")
    end

    it "should delete group contact", js: true do
      create(:group_contact)
      user.update_attribute(:admin, true)
      click_button "Sök"
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      expect(page).to have_selector(".flash.notice", text: "raderades")
    end
  end
end
