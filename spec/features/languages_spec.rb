# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Languages" do
  let(:user) { create(:user) }

  it "should be protected from regular users" do
    login(user.username, "") # Stubbed auth
    visit languages_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  describe "administration" do
    before(:each) do
      user.update_attribute(:admin, true)
      login(user.username, "") # Stubbed auth
      create_list(:language, 10)
      visit languages_path
    end

    it "should be available to admins" do
      page.should have_selector('h1.box-title', text: "Språk")
    end

    it "should have languages" do
      page.all('section.box table tr').count.should > 10
    end

    it "should have an edit form" do
      first('section.box table tbody td a').click
      page.should have_selector('h1.box-title', text: "Redigera språk")
    end

    it "should create language" do
      click_on('Lägg till')
      fill_in "language_name", with: "Svenska"
      click_button "Spara"
      page.should have_selector(".notice", text: "skapades")
    end

    it "should update language" do
      visit edit_language_path(Language.first)
      fill_in "language_name", with: "Swahili"
      click_button "Spara"
      page.should have_selector(".notice", text: "uppdaterades")
    end

    it "should delete language", js: true do
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      page.should have_selector(".notice", text: "raderades")
    end

    it "should not merge language without a second language" do
      visit edit_language_path(Language.first)
      click_on("Slå samman med")
      click_button "Slå samman"
      page.should have_selector(".warning", text: "Du måste välja ett språk från listan")
    end

    it "should merge language", js: true do
      visit edit_language_path(Language.first)
      click_on("Slå samman med")

      page.execute_script "$('#into').val('#{Language.last.name}').trigger('focus').trigger('keydown')"
      page.should have_selector("ul.ui-autocomplete li.ui-menu-item a")

      item_selector = "ul.ui-autocomplete li.ui-menu-item:last-child a"
      page.should have_selector(item_selector)

      page.execute_script "$('#{item_selector}').trigger('mouseenter').trigger('click')"
      click_button "Slå samman"
      page.should have_selector(".notice", text: "har slagits ihop med")
    end
  end
end
