# -*- coding: utf-8 -*-
require 'spec_helper'

describe Projects do
  it "should be created" do
    expect { create(:project) }.to change(Project, :count).by(+1)
  end

  it "should be valid" do
    build(:project).should be_valid
  end

  it "should require a name" do
    build(:project, name: "").should_not be_valid
  end

  it "should validate the length" do
    build(:project, name: "fox barx" * 10).should_not be_valid
  end

  it "should validate the uniqueness" do
    create(:project, name: "fox")
    build(:project, name: "fox").should_not be_valid
  end

  it "should be destroyed" do
    project = create(:project)
    expect { project.destroy }.to change(Project, :count).by(-1)
  end

  describe "merged" do
    before(:each) do
      @project_1 = create(:project)
      @user_1 = create(:user, projects: [@project_1])
      @project_2 = create(:project)
      @user_2 = create(:user, projects: [@project_2])
    end

    it "should destroy the first project" do
      expect { @project_1.merge(@project_2) }.to change(Project, :count).by(-1)
    end

    it "should not destroy the second project" do
      @project_1.merge(@project_2)
      expect(Project.last).to eq(@project_2)
    end

    it "should not change a users number of projects (if she don't have both)" do
      expect { @project_1.merge(@project_2) }.to change(@user_1.projects, :count).by(0)
    end

    it "should change a users number of projects (if she has both)" do
      @user_1.projects << @project_2
      expect { @project_1.merge(@project_2) }.to change(@user_1.projects, :count).by(-1)
    end
  end
end
