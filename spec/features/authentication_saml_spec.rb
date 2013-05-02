# -*- coding: utf-8 -*-
require 'spec_helper'

if APP_CONFIG["auth_method"] == "saml"
  feature "SAML authentication" do
    scenario "should redirect the user to the IdP login page" do
      visit root_path
      current_url.should match(/#{APP_CONFIG["saml"]["idp_sso_target_url"]}/)
    end

    scenario "should require login for profile page" do
      user = FactoryGirl.create(:user)
      visit user_path(user.username)
      current_url.should match(/#{APP_CONFIG["saml"]["idp_sso_target_url"]}/)
    end

    scenario "should require login for an admin page" do
      visit roles_path
      current_url.should match(/#{APP_CONFIG["saml"]["idp_sso_target_url"]}/)
    end

    scenario "should sign in a user with correct credentials" do
      # user = FactoryGirl.create(:user, username: AUTH_CREDENTIALS["username"])
      visit root_url
      # page.should have_selector('h1')
      # page.should have_field("username")
      # page.should have_field("password")
      # fill_in 'username', with: user.username
      # fill_in 'password', with: AUTH_CREDENTIALS["password"]
      # find('input[type="submit"]').click
      # current_path.should eq(root_path)
      # page.should have_selector('h1', text: "Mina Kominnyheter")
    end
  end
end
