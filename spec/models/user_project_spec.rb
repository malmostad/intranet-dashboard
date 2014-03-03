require 'spec_helper'

describe UserProject do
  let(:project) { create(:project) }
  let(:user) { create(:user) }

  it "should associate a project to a user" do
    UserProject.create(user_id: user.id, project_id: project.id)
    user.projects.should be_present
  end

  it "should remove the association of project on destroy" do
    project.destroy
    user.projects.should_not be_present
  end
end
