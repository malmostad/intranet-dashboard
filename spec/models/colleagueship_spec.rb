# -*- coding: utf-8 -*-
require 'spec_helper'

describe Colleagueship do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }

  it "should not be set" do
    follower.colleagueships.should be_blank
  end

  it "should be set" do
    Colleagueship.create(user_id: follower.id, colleague_id: followed.id)
    follower.colleagueships.should be_present
  end

  it "should be removed" do
    Colleagueship.create(user_id: follower.id, colleague_id: followed.id)
    followed.destroy
    follower.colleagueships.should be_blank
  end
end
