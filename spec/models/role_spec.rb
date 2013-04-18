# -*- coding: utf-8 -*-
require 'spec_helper'

describe Role do
  let(:role) { FactoryGirl.create(:role) }

  it "should be valid" do
    FactoryGirl.build(:role).should be_valid
  end

  it "should be created" do
    expect { FactoryGirl.create(:role) }.to change(Role, :count).by(1)
  end

  it "should have a unique name" do
    FactoryGirl.build(:role, name: role.name).should_not be_valid
  end

  it "should not be valid without a category" do
    FactoryGirl.build(:role, category: nil).should_not be_valid
  end

  it "should not be valid without a homepage" do
    FactoryGirl.build(:role, homepage_url: nil).should_not be_valid
  end

  it "should have a homepage" do
    role.homepage_url.should be_present
  end

  it "should have a valid category" do
    Role::CATEGORIES.should have_key(role.category)
  end

  it "should be destroyed" do
    role = FactoryGirl.create(:role)
    expect { role.destroy }.to change(Role, :count).by(-1)
  end
end
