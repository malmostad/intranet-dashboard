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

  describe "merged" do
    before(:each) do
      @skill_1 = create(:skill)
      @user_1 = create(:user, skills: [@skill_1])
      @skill_2 = create(:skill)
      @user_2 = create(:user, skills: [@skill_2])
    end

    it "should destroy the first language" do
      expect { @skill_1.merge(@skill_2) }.to change(Language, :count).by(-1)
    end

    it "should not destroy the second language" do
      @skill_1.merge(@skill_2)
      expect(Language.last).to eq(@skill_2)
    end

    it "should not change a users number of skills (if she don't have both)" do
      expect { @skill_1.merge(@skill_2) }.to change(@user_1.skills, :count).by(0)
    end

    it "should change a users number of skills (if she has both)" do
      @user_1.skills << @skill_2
      expect { @skill_1.merge(@skill_2) }.to change(@user_1.skills, :count).by(-1)
    end
  end
end
