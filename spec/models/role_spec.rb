# -*- coding: utf-8 -*-
require 'spec_helper'

describe Role do
  let(:role) { create(:role) }

  it "should be valid" do
    expect(build(:role)).to be_valid
  end

  it "should be created" do
    expect { create(:role) }.to change(Role, :count).by(1)
  end

  it "should have a unique name" do
    expect(build(:role, name: role.name)).not_to be_valid
  end

  it "should not be valid without a category" do
    expect(build(:role, category: nil)).not_to be_valid
  end

  it "should not be valid without a homepage" do
    expect(build(:role, homepage_url: nil)).not_to be_valid
  end

  it "should have a homepage" do
    expect(role.homepage_url).to be_present
  end

  it "should have a valid category" do
    expect(Role::CATEGORIES).to have_key(role.category)
  end

  it "should be destroyed" do
    role = create(:role)
    expect { role.destroy }.to change(Role, :count).by(-1)
  end
end
