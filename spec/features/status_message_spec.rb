# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Status message" do
  scenario "should not be set" do
    create_user_and_login
    visit root_path
    page.should have_selector('#my-status .status', text: "Jag har ingen status än!")
  end

  scenario "should be set" do
    user = FactoryGirl.create(:user_with_status_message)
    login(user.username, 'stub')
    visit root_path
    page.should_not have_selector('#my-status .status', text: "Jag har ingen status än!")
  end

  scenario "should be set interactively", js: true do
    create_user_and_login
    visit root_path
    status = 'My new status message'
    find('#status_message').set status
    page.execute_script("$('#update-status-form').submit()")
    page.should have_selector('#my-status .status', text: status)
  end
end
