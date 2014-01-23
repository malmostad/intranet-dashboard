# -*- coding: utf-8 -*-
require 'spec_helper'

if APP_CONFIG["auth_method"] == "ldap"
  describe "LDAP authentication" do
    it "should sign in a user with correct credentials" do
      create_ldap_user
      login_ldap_user
      current_path.should eq(root_path)
      page.should have_selector('h1', text: "Mina Kominnyheter")
    end

    it "should require admin role" do
      create_ldap_user
      login_ldap_user
      visit feeds_path
      page.should have_selector('.error', text: "Du saknar behörighet")
    end

    it "should honor admin role" do
      user = create_ldap_user
      user.update_attribute(:admin, true)
      login_ldap_user
      visit feeds_path
      page.should have_selector('h1', text: "Nyhetsflöden")
    end
  end
end
