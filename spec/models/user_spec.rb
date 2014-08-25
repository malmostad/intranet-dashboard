# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  it "must have a username" do
    user.username = nil
    user.should_not be_valid
  end

  it "should have an email" do
    user.email.should be_present
  end

  it "should have a first and last name" do
    user.first_name.should be_present
    user.last_name.should be_present
  end

  it "should have a unique username" do
    create(:user, username: "fox")
    build(:user, username: "fox").should_not be_valid
  end

  it "should be deleted" do
    u = create(:user)
    expect { u.destroy }.to change(User, :count).by(-1)
  end

  it "should get a manager" do
    manager = create(:user)
    user.update_attribute(:manager, manager)
    user.manager.should be_present
    manager.subordinates.should be_present
  end

  it "should have a protocol for the LinkeIn URL" do
    user.update(linkedin: "www.linkedin.com/in/fox")
    user.linkedin.should eq("https://www.linkedin.com/in/fox")
  end

  it "should get rid of her manager" do
    manager = create(:user)
    user.update_attribute(:manager, manager)
    manager.destroy
    user.reload
    user.manager.should_not be_present
  end
end
