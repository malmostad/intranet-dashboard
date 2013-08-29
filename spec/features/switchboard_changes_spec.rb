# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SwitchboardChanges" do
  before(:each) do
    @ldap_user = create_ldap_user
    login_ldap_user
    visit new_switchboard_change_path
  end

  it "should have a form" do
    page.should have_selector('#room')
    page.should have_selector('#address')
    page.should have_selector('#comment')
  end

  it "should invalidate an empty form" do
    click_on("Sänd")
    current_path.should eq(switchboard_changes_path)
    page.should have_selector(".flash.warning")
  end

  it "should send the form" do
    fill_in :room, with: "123"
    fill_in :address, with: "Sunset Boulevard"
    click_on("Sänd")
    current_path.should eq(user_path(@ldap_user.username))
    page.should have_selector(".flash.notice", text: "skickats till televäxeln.")
  end
end
