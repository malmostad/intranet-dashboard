# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Skills" do
  it "should be protected from regular users" do
    create_ldap_user
    login_ldap_user
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end
end
