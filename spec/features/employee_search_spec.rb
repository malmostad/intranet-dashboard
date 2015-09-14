# -*- coding: utf-8 -*-
require 'spec_helper'

describe "EmployeeSearch" do
  it "should require login" do
    visit users_search_path
    expect(current_path).to eq login_path
  end

  describe "for authenticated users" do
    let(:user) { create :user }
    before(:each) do
      login user.username, "" # Stubbed auth
      visit users_search_path
    end

    it "should have a search form" do
      expect(page).to have_selector 'form #query-employee'
    end

    # it "should have search results (if Elasticsearch is fast enough at indexing)" do
    #   create(:user)
    #   sleep 2
    #   fill_in 'query-employee', with: "#{user.first_name} #{user.last_name}"
    #   click_button "Sök"
    #   expect(page).to have_selector "ul.results li.vcard"
    # end
  end
end
