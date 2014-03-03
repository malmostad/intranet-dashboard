# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Projects" do
  let(:user) { create(:user) }

  it "should be protected from regular users" do
    login(user.username, "") # Stubbed auth
    visit projects_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  describe "administration" do
    before(:each) do
      user.update_attribute(:admin, true)
      login(user.username, "") # Stubbed auth
      create_list(:project, 10)
      visit projects_path
      click_button "Sök"
    end

    it "should be available to admins" do
      page.should have_selector('h1.box-title', text: "Kunskapsområde")
    end

    it "should have projects" do
      page.all('section.box table tr').count.should > 10
    end

    it "should have an edit form" do
      first('section.box table tbody td a').click
      page.should have_selector('h1.box-title', text: "Redigera")
    end

    it "should create project" do
      click_on('Lägg till')
      fill_in "project_name", with: "Excel"
      click_button "Spara"
      page.should have_selector(".notice", text: "skapades")
    end

    it "should update project" do
      visit edit_project_path(Project.first)
      fill_in "project_name", with: "PowerPoint"
      click_button "Spara"
      page.should have_selector(".notice", text: "uppdaterades")
    end

    it "should delete project", js: true do
      first("a.btn-danger").click
      page.evaluate_script("window.confirm()")
      page.should have_selector(".notice", text: "raderades")
    end

    it "should not merge project without a second project" do
      visit edit_project_path(Project.first)
      click_on("Slå samman med")
      click_button "Slå samman"
      page.should have_selector(".warning", text: "Du måste välja")
    end

    it "should merge project", js: true do
      visit edit_project_path(Project.first)
      click_on("Slå samman med")

      page.execute_script "$('#into').val('#{Project.limit(2).last.name}').trigger('focus').trigger('keydown')"
      page.should have_selector("ul.ui-autocomplete li.ui-menu-item a")

      item_selector = "ul.ui-autocomplete li.ui-menu-item:last-child a"
      page.should have_selector(item_selector)

      page.execute_script "$('#{item_selector}').trigger('mouseenter').trigger('click')"
      click_button "Slå samman"
      page.should have_selector(".notice", text: "har slagits ihop med")
    end
  end
end
