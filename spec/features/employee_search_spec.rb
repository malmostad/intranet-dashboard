# -*- coding: utf-8 -*-
require 'spec_helper'

describe "EmployeeSearch" do
  it "should require login" do
    visit users_search_path
    current_path.should eq login_path
  end

  describe "for authenticated users" do
    let(:user) { create :user }
    before(:each) do
      login user.username, "" # Stubbed auth
      visit users_search_path
    end

    it "should have a search form" do
      page.should have_selector 'form #query-employee'
    end

    it "should have search results (if Elasticsearch is up and running)" do
      create(:user)
      fill_in 'query-employee', with: "#{user.first_name} #{user.last_name}"
      click_button "Sök"
      page.should have_selector "ul.results li.vcard"
    end
  end
end
