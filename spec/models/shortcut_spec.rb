# -*- coding: utf-8 -*-
require 'spec_helper'

describe Shortcut do
  it "should be valid" do
    build(:shortcut).should be_valid
  end

  it "should have an url" do
    build(:shortcut, url: "").should be_invalid
  end

  it "should have a valid url" do
    build(:shortcut, url: "http://x.y").should be_invalid
  end

  it "should have a name" do
    build(:shortcut, name: "").should be_invalid
  end

  it "should have a name" do
    create(:shortcut).name.should be_present
  end

  it "should be created" do
    expect { create(:shortcut) }.to change(Shortcut, :count).by(1)
  end

  it "should have a feed_url" do
    create(:shortcut).url.should be_present
  end

  it "should have a valid category" do
    shortcut = build(:shortcut)
    Shortcut::CATEGORIES.should have_key(shortcut.category)
  end

  it "should be destroyed" do
    shortcut = create(:shortcut)
    expect { shortcut.destroy }.to change(Shortcut, :count).by(-1)
  end
end
