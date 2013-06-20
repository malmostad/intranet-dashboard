# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Global assets javascript" do
  before(:each) do
    create_ldap_user
    login_ldap_user
  end

  it "should have injected the masthead", js: true do
    page.should have_selector('header#malmo-masthead')
  end

  it "should have a link to Our organization", js: true do
    page.should have_selector('#nav-our-organization', text: 'Vår kommun')
  end

  it "should have a link to the dashboard", js: true do
    page.should have_selector('#nav-dashboard', text: 'Min sida')
  end

  it "should have a form for employee search", js: true do
    find('#nav-search-trigger a').click
    page.should have_selector('#masthead-search-person')
  end

  it "should have a form for intranet search", js: true do
    find('#nav-search-trigger a').click
    page.should have_selector('#masthead-search-intranet')
  end
end
