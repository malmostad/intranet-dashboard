# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Authorization" do
  scenario "should require admin role" do
    user = FactoryGirl.create(:user)
    visit login_path
    fill_in 'username', with: user.username
    click_button 'Logga in'
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  scenario "should honor admin role" do
    user = FactoryGirl.create(:admin_user)
    visit login_path
    fill_in 'username', with: user.username
    click_button 'Logga in'
    visit feeds_path
    page.should have_selector('h1', text: "Nyhetsflöden")
  end
end
