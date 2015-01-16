# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Global assets javascript" do
  let(:user) { create(:user) }
  before(:each) do
    login(user.username, "") # Stubbed auth
    page.driver.browser.resize(1200, 800)
  end

  it "should have injected the masthead", js: true do
    expect(page).to have_selector('header#malmo-masthead')
  end

  it "should have a link to Our organization", js: true do
    expect(page).to have_selector('#nav-our-organization', text: 'Vår kommun')
  end

  it "should have a link to the dashboard", js: true do
    expect(page).to have_selector('#nav-dashboard', text: 'Min sida')
  end

  it "should have a form for employee search", js: true do
    find('#masthead-q-komin').click
    expect(page).to have_selector('#masthead-search-person')
  end

  it "should have a form for intranet search", js: true do
    find('#masthead-q-komin').click
    expect(page).to have_selector('#masthead-search-intranet')
  end
end
