# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Users shortcuts" do
  let(:user) { create(:user) }
  let(:tools_and_systems) { create(:shortcut, category: "tools_and_systems") }
  let(:i_want) { create(:shortcut, category: "i_want") }

  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "should not have any 'Tools' shortcuts" do
    expect(page).not_to have_selector('#shortcuts-tools .my ul li')
  end

  it "should not have any 'I want' shortcuts" do
    expect(page).not_to have_selector('#shortcuts-i-want ul li')
  end

  describe "" do
    before(:each) {
      user.shortcuts << tools_and_systems
      user.shortcuts << i_want
      visit root_path
    }

    it "should have a 'Tools' shortcut" do
      expect(page).to have_selector('#shortcuts-tools .my ul li')
    end

    it "should have an 'I want' shortcut" do
      expect(page).to have_selector('#shortcuts-i-want ul li')
    end

    it "should remove a 'Tools' shortcut", js: true do
      find("#shortcuts-tools .remove").click
      expect(page).not_to have_selector('#shortcuts-tools .my ul li')
    end

    it "should remove an 'I want' shortcut", js: true do
      find("#shortcuts-i-want .remove").click
      expect(page).not_to have_selector('#shortcuts-i-want ul li')
    end
  end
end
