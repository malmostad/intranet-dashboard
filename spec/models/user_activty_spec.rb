require 'spec_helper'

describe UserActivity do
  let(:activity) { create(:activity) }
  let(:user) { create(:user) }

  it "should associate a activity to a user" do
    UserActivity.create(user_id: user.id, activity_id: activity.id)
    user.activities.should be_present
  end

  it "should remove the association of activity on destroy" do
    activity.destroy
    user.activities.should_not be_present
  end
end
