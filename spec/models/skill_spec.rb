# -*- coding: utf-8 -*-
require 'spec_helper'

describe Skill do
  it "should be created" do
    expect { create(:skill) }.to change(Skill, :count).by(+1)
  end

  it "should be valid" do
    expect(build(:skill)).to be_valid
  end

  it "should require a name" do
    expect(build(:skill, name: "")).not_to be_valid
  end

  it "should validate the length" do
    expect(build(:skill, name: "fox barx" * 10)).not_to be_valid
  end

  it "should validate the uniqueness" do
    create(:skill, name: "fox")
    expect(build(:skill, name: "fox")).not_to be_valid
  end

  it "should be destroyed" do
    skill = create(:skill)
    expect { skill.destroy }.to change(Skill, :count).by(-1)
  end

  describe "merged" do
    before(:each) do
      @skill_1 = create(:skill)
      @user_1 = create(:user, skills: [@skill_1])
      @skill_2 = create(:skill)
      @user_2 = create(:user, skills: [@skill_2])
    end

    it "should destroy the first skill" do
      expect { @skill_1.merge(@skill_2) }.to change(Skill, :count).by(-1)
    end

    it "should not destroy the second skill" do
      @skill_1.merge(@skill_2)
      expect(Skill.last).to eq(@skill_2)
    end

    it "should not change a users number of skills (if she doesn't have both)" do
      expect { @skill_1.merge(@skill_2) }.to change(@user_1.skills, :count).by(0)
    end

    it "should change a users number of skills (if she has both)" do
      @user_1.skills << @skill_2
      expect { @skill_1.merge(@skill_2) }.to change(@user_1.skills, :count).by(-1)
    end
  end
end
