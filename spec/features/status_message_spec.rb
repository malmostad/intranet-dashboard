# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Status message" do
  it "should not be set, yet" do
    create_ldap_user
    login_ldap_user
    page.should have_selector('#my-status .status', text: "Jag har ingen status än!")
  end

  it "should be displayed" do
    ldap_user = create_ldap_user
    ldap_user.update_attribute(:status_message, "It’s work, all that matters is work")
    login_ldap_user
    page.should have_selector('#my-status .updated_at')
    page.should_not have_selector('#my-status .status', text: "Jag har ingen status än!")
  end

  it "should be set via xhr", js: true do
    create_ldap_user
    login_ldap_user
    status = 'My new status message'
    find('#status_message').set status
    page.execute_script("$('#update-status-form').submit()")
    page.should have_selector('#my-status .status', text: status)
  end
end
