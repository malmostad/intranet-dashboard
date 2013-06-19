# -*- coding: utf-8 -*-
require 'spec_helper'

describe Skill do
  it "should be created" do
    expect { create(:skill) }.to change(Skill, :count).by(+1)
  end

  it "should be valid" do
    build(:skill).should be_valid
  end

  it "should require a name" do
    build(:skill, name: "").should_not be_valid
  end

  it "should validate the length" do
    build(:skill, name: "fox barx" * 10).should_not be_valid
  end

  it "should validate the uniqueness" do
    create(:skill, name: "fox")
    build(:skill, name: "fox").should_not be_valid
  end

  it "should be destroyed" do
    skill = create(:skill)
    expect { skill.destroy }.to change(Skill, :count).by(-1)
  end
end
