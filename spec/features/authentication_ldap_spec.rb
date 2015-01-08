# -*- coding: utf-8 -*-
require 'spec_helper'

if APP_CONFIG["ldap"]["enabled"]
  describe "LDAP authentication" do
    before(:each) do
      # Disable stub for ldap specs
      @stub_auth = APP_CONFIG["stub_auth"]
      APP_CONFIG["stub_auth"] = false
      create_ldap_user
    end

    after(:each) do
      # Reset stub setting to not affect other specs
      APP_CONFIG["stub_auth"] = @stub_auth
    end

    it "should not sign in a user without username and password" do
      visit login_path
      fill_in 'username', with: ''
      fill_in 'password', with: ''
      click_button 'Logga in'
      expect(current_path).to eq(login_path)
      expect(page).to have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should not sign in a user without password" do
      visit login_path
      fill_in 'username', with: AUTH_CREDENTIALS["username"]
      fill_in 'password', with: ''
      click_button 'Logga in'
      expect(current_path).to eq(login_path)
      expect(page).to have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should not sign in a user without incorrect password" do
      visit login_path
      fill_in 'username', with: AUTH_CREDENTIALS["username"]
      fill_in 'password', with: 'barx'
      click_button 'Logga in'
      expect(current_path).to eq(login_path)
      expect(page).to have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should not sign in a user with incorrect credentials" do
      visit login_path
      fill_in 'username', with: 'Fox'
      fill_in 'password', with: 'barx'
      click_button 'Logga in'
      expect(current_path).to eq(login_path)
      expect(page).to have_selector('.warning', text: 'Fel användarnamn eller lösenord')
    end

    it "should sign in a user with correct credentials" do
      login_ldap_user
      expect(current_path).to eq(root_path)
      expect(page).to have_selector('h1', text: "Nyheter & diskussioner")
    end
  end
end
