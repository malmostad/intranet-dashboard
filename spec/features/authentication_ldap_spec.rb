# -*- coding: utf-8 -*-
require 'spec_helper'

if APP_CONFIG["auth_method"] == "ldap"
  APP_CONFIG["stub_auth"] = false

  describe "LDAP authentication" do
    before(:each) do
      create_ldap_user
    end

    it "should not sign in a user without username and password" do
      visit login_path
      fill_in 'username', with: ''
      fill_in 'password', with: ''
      click_button 'Logga in'
      current_path.should eq(login_path)
      page.should have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should not sign in a user without password" do
      visit login_path
      fill_in 'username', with: AUTH_CREDENTIALS["username"]
      fill_in 'password', with: ''
      click_button 'Logga in'
      current_path.should eq(login_path)
      page.should have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should not sign in a user without incorrect password" do
      visit login_path
      fill_in 'username', with: AUTH_CREDENTIALS["username"]
      fill_in 'password', with: 'barx'
      click_button 'Logga in'
      current_path.should eq(login_path)
      page.should have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should not sign in a user with incorrect credentials" do
      visit login_path
      fill_in 'username', with: 'Fox'
      fill_in 'password', with: 'barx'
      click_button 'Logga in'
      current_path.should eq(login_path)
      page.should have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should sign in a user with correct credentials" do
      login_ldap_user
      current_path.should eq(root_path)
      page.should have_selector('h1', text: "Mina Kominnyheter")
    end
  end
end
