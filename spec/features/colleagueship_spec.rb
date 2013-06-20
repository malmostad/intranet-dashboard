# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Colleagueships" do
  it "should not be set" do
    create_ldap_user
    login_ldap_user
    page.should have_selector('.no-colleagues')
  end

  it "should be set" do
    ldap_user = create_ldap_user
    followed = create(:user)
    Colleagueship.create(user_id: ldap_user.id, colleague_id: followed.id)
    login_ldap_user
    page.should_not have_selector('.no-colleagues')
    page.should have_xpath("//li[not(@id='my-status')][1]", text: followed.displayname)
  end
end
