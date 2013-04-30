# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Global assets javascript" do
  before(:each) do
    visit login_path
  end

  scenario "should have injected the masthead", js: true do
    page.should have_selector('header#malmo-masthead')
  end

  scenario "should have a link to Our organization", js: true do
    page.should have_selector('#nav-our-organization', text: 'Vår kommun')
  end

  scenario "should have a link to the dashboard", js: true do
    page.should have_selector('#nav-dashboard', text: 'Min sida')
  end

  scenario "should have a form for employee search", js: true do
    find('#nav-search-trigger a').click
    page.should have_selector('#masthead-search-person')
  end

  scenario "should have a form for intranet search", js: true do
    find('#nav-search-trigger a').click
    page.should have_selector('#masthead-search-intranet')
  end
end
