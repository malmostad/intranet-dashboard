# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Skills" do
  let(:ldap_user) { create_ldap_user }

  before(:each) do
    create_feeds_for_user(ldap_user)
    login_ldap_user
  end

  it "should be protected from regular users" do
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end
end
