# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Status message" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "should not be set, yet" do
    expect(page).to have_selector('#my-status .status', text: "Jag har ingen status än!")
  end

  it "should be displayed" do
    user.update_attribute(:status_message, "It’s work, all that matters is work")
    visit root_path
    expect(page).to have_selector('#my-status .updated_at')
    expect(page).not_to have_selector('#my-status .status', text: "Jag har ingen status än!")
  end

  it "should be set via xhr", js: true do
    status = 'My new status message'
    find('#status_message').set status
    page.execute_script("$('#update-status-form').submit()")
    sleep 1
    expect(page).to have_selector('#my-status .status', text: status)
  end
end
