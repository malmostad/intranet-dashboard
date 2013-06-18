# -*- coding: utf-8 -*-
require 'spec_helper'

feature "Colleagueships" do
  scenario "should not be set" do
    create_user_and_login
    visit root_path
    page.should have_selector('.no-colleagues')
  end

  scenario "should be set" do
    follower = create(:user, username: AUTH_CREDENTIALS["username"])
    followed = create(:user)
    Colleagueship.create(user_id: follower.id, colleague_id: followed.id)
    login(follower.username, AUTH_CREDENTIALS["password"])
    visit root_path
    page.should_not have_selector('.no-colleagues')
    page.should have_xpath("//li[not(@id='my-status')][1]", text: followed.displayname)
  end
end
