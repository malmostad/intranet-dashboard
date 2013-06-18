# -*- coding: utf-8 -*-
require 'spec_helper'

describe Role do
  let(:role) { create(:role) }

  it "should be valid" do
    build(:role).should be_valid
  end

  it "should be created" do
    expect { create(:role) }.to change(Role, :count).by(1)
  end

  it "should have a unique name" do
    build(:role, name: role.name).should_not be_valid
  end

  it "should not be valid without a category" do
    build(:role, category: nil).should_not be_valid
  end

  it "should not be valid without a homepage" do
    build(:role, homepage_url: nil).should_not be_valid
  end

  it "should have a homepage" do
    role.homepage_url.should be_present
  end

  it "should have a valid category" do
    Role::CATEGORIES.should have_key(role.category)
  end

  it "should be destroyed" do
    role = create(:role)
    expect { role.destroy }.to change(Role, :count).by(-1)
  end
end
