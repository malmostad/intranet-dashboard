# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Authentication" do
  scenario "should require login for the dashboard" do
    visit root_path
    current_path.should eq(login_path)
    page.should have_selector('h1', text: "Logga in")
    page.should have_field("password")
  end

  scenario "should require login for profile page" do
    user = FactoryGirl.create(:user)
    visit user_path(user.username)
    current_path.should eq(login_path)
    page.should have_selector('h1', text: "Logga in")
  end

  scenario "should require login for an admin page" do
    visit roles_path
    current_path.should eq(login_path)
    page.should have_selector('h1', text: "Logga in")
  end

  scenario "should not sign in a user with incorrect credentials" do
    visit login_path
    fill_in 'username', with: 'Fox'
    fill_in 'password', with: 'barx'
    click_button 'Logga in'
    current_path.should eq(login_path)
    page.should have_selector('.warning', text: 'Fel användarnamn eller lösenord')
  end

  scenario "should not sign in a user without credentials" do
    visit login_path
    fill_in 'username', with: ''
    fill_in 'password', with: ''
    click_button 'Logga in'
    current_path.should eq(login_path)
    page.should have_selector('.warning', text: 'Fel användarnamn eller lösenord')
  end

  scenario "should sign in a user with correct credentials" do
    create_user_and_login
    current_path.should eq(root_path)
    page.should have_selector('h1', text: "Mina Kominnyheter")
  end
end