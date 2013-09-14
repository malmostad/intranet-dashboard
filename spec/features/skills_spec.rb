# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Skills" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
  end

  it "should be protected from regular users" do
    visit feeds_path
    page.should have_selector('.error', text: "Du saknar behörighet")
  end
end
