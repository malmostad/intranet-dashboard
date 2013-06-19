# -*- coding: utf-8 -*-
require 'spec_helper'

describe UserSkill do
  let(:skill) { create(:skill) }
  let(:user) { create(:user) }

  it "should associate a skill to a user" do
    UserSkill.create(user_id: user.id, skill_id: skill.id)
    user.skills.should be_present
  end

  it "should remove the association of skill on destroy" do
    skill.destroy
    user.skills.should_not be_present
  end
end
