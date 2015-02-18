# -*- coding: utf-8 -*-
require 'spec_helper'

describe " Authentication (stub)" do
  it "should require login for the dashboard" do
    visit root_path
    expect(current_path).to eq(login_path)
    expect(page).to have_selector('h1', text: "Logga in")
    expect(page).to have_field("password")
  end

  it "should require login for profile page" do
    user = create(:user)
    visit user_path(user.username)
    expect(current_path).to eq(login_path)
    expect(page).to have_selector('h1', text: "Logga in")
  end

  it "should require login for an admin page" do
    visit roles_path
    expect(current_path).to eq(login_path)
    expect(page).to have_selector('h1', text: "Logga in")
  end

  it "should not sign in a user without credentials" do
    login('', '')
    expect(current_path).to eq(login_path)
    expect(page).to have_selector('.warning', text: 'Användarnamnet finns inte')
  end

  it "should require admin role" do
    user = create(:user)
    login(user.username, '')
    visit feeds_path
    expect(page).to have_selector('.error', text: "Du saknar behörighet")
  end

  it "should honor admin role" do
    user = create(:user)
    login(user.username, '')
    user.update_attribute(:admin, true)
    visit feeds_path
    expect(page).to have_selector('h1', text: "Nyhetsflöden")
  end

  it "should redirect to requested page after login" do
    user = create(:user)
    visit user_path(user.username)
    expect(current_path).to eq(login_path)
    fill_in 'username', with: user.username
    fill_in 'password', with: "bar"
    click_button 'Logga in'
    expect(current_path).to eq(user_path(user.username))
  end

  it "should not register ajax request as request to redirect after login", js: true do
    user = create(:user)
    visit user_path(user.username)
    page.execute_script "$.get('#{users_path}')"
    fill_in 'username', with: user.username
    fill_in 'password', with: "bar"
    click_button 'Logga in'
    expect(current_path).to eq(user_path(user.username))
  end
end
