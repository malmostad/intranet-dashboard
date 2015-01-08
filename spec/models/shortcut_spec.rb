# -*- coding: utf-8 -*-
require 'spec_helper'

describe Shortcut do
  it "should be valid" do
    expect(build(:shortcut)).to be_valid
  end

  it "should have an url" do
    expect(build(:shortcut, url: "")).to be_invalid
  end

  it "should have a valid url" do
    expect(build(:shortcut, url: "http://x.y")).to be_invalid
  end

  it "should have a name" do
    expect(build(:shortcut, name: "")).to be_invalid
  end

  it "should have a name" do
    expect(create(:shortcut).name).to be_present
  end

  it "should be created" do
    expect { create(:shortcut) }.to change(Shortcut, :count).by(1)
  end

  it "should have a feed_url" do
    expect(create(:shortcut).url).to be_present
  end

  it "should have a valid category" do
    shortcut = build(:shortcut)
    expect(Shortcut::CATEGORIES).to have_key(shortcut.category)
  end

  it "should be destroyed" do
    shortcut = create(:shortcut)
    expect { shortcut.destroy }.to change(Shortcut, :count).by(-1)
  end
end
