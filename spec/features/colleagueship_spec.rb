# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Colleagueships" do
  it "should not be set" do
    create_ldap_user_and_login
    visit root_path
    page.should have_selector('.no-colleagues')
  end

  it "should be set" do
    follower = create_named_user
    followed = create(:user)
    Colleagueship.create(user_id: follower.id, colleague_id: followed.id)
    login(follower.username, AUTH_CREDENTIALS["password"])
    visit root_path
    page.should_not have_selector('.no-colleagues')
    page.should have_xpath("//li[not(@id='my-status')][1]", text: followed.displayname)
  end
end
