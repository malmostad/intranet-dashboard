# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  it "must have a username" do
    user.username = nil
    expect(user).not_to be_valid
  end

  it "should have an email" do
    expect(user.email).to be_present
  end

  it "should have a first and last name" do
    expect(user.first_name).to be_present
    expect(user.last_name).to be_present
  end

  it "should have a unique username" do
    create(:user, username: "fox")
    expect(build(:user, username: "fox")).not_to be_valid
  end

  it "should be deleted" do
    u = create(:user)
    expect { u.destroy }.to change(User, :count).by(-1)
  end

  it "should get a manager" do
    manager = create(:user)
    user.update_attribute(:manager, manager)
    expect(user.manager).to be_present
    expect(manager.subordinates).to be_present
  end

  it "should have a protocol for the LinkeIn URL" do
    user.update(linkedin: "www.linkedin.com/in/fox")
    expect(user.linkedin).to eq("https://www.linkedin.com/in/fox")
  end

  it "should get rid of her manager" do
    manager = create(:user)
    user.update_attribute(:manager, manager)
    manager.destroy
    user.reload
    expect(user.manager).not_to be_present
  end
end
