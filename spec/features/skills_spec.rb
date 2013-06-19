# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Skills" do
  scenario "should be protected from regular users" do
    create_ldap_user_and_login
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end

  scenario "should be protected from regular users" do
    create_ldap_user_and_login
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end
end
