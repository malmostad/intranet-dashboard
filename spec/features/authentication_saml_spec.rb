# -*- coding: utf-8 -*-
require 'spec_helper'

if APP_CONFIG["saml"]["enabled"]
  describe "SAML authentication" do
    it "should redirect the user to the IdP login page" do
      visit root_path
      expect(current_url).to match(/#{APP_CONFIG["saml"]["idp_sso_target_url"]}/)
    end

    it "should require login for profile page" do
      user = create(:user)
      visit user_path(user.username)
      expect(current_url).to match(/#{APP_CONFIG["saml"]["idp_sso_target_url"]}/)
    end

    it "should require login for an admin page" do
      visit roles_path
      expect(current_url).to match(/#{APP_CONFIG["saml"]["idp_sso_target_url"]}/)
    end

    it "should sign in a user with correct credentials" do
      # user = create(:user, username: AUTH_CREDENTIALS["username"])
      # visit root_url
      # expect(page).to have_selector('h1')
      # expect(page).to have_field("username")
      # expect(page).to have_field("password")
      # fill_in 'username', with: user.username
      # fill_in 'password', with: AUTH_CREDENTIALS["password"]
      # find('input[type="submit"]').click
      # expect(current_path).to eq(root_path)
      # expect(page).to have_selector('h1', text: "Mina Kominnyheter")
    end
  end
end
