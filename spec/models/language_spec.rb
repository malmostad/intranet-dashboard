# -*- coding: utf-8 -*-
require 'spec_helper'

describe Language do
  it "should be created" do
    expect { create(:language) }.to change(Language, :count).by(+1)
  end

  it "should be valid" do
    build(:language).should be_valid
  end

  it "should require a name" do
    build(:language, name: "").should_not be_valid
  end

  it "should validate the length" do
    build(:language, name: "fox barx" * 10).should_not be_valid
  end

  it "should validate the uniqueness" do
    create(:language, name: "fox")
    build(:language, name: "fox").should_not be_valid
  end

  it "should be destroyed" do
    language = create(:language)
    expect { language.destroy }.to change(Language, :count).by(-1)
  end
end
