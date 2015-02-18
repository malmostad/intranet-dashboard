# -*- coding: utf-8 -*-
require 'spec_helper'

describe Activity do
  it "should be created" do
    expect { create(:activity) }.to change(Activity, :count).by(+1)
  end

  it "should be valid" do
    expect(build(:activity)).to be_valid
  end

  it "should require a name" do
    expect(build(:activity, name: "")).not_to be_valid
  end

  it "should validate the length" do
    expect(build(:activity, name: "fox barx" * 10)).not_to be_valid
  end

  it "should validate the uniqueness" do
    create(:activity, name: "fox")
    expect(build(:activity, name: "fox")).not_to be_valid
  end

  it "should be destroyed" do
    activity = create(:activity)
    expect { activity.destroy }.to change(Activity, :count).by(-1)
  end

  describe "merged" do
    before(:each) do
      @activity_1 = create(:activity)
      @user_1 = create(:user, activities: [@activity_1])
      @activity_2 = create(:activity)
      @user_2 = create(:user, activities: [@activity_2])
    end

    it "should destroy the first activity" do
      expect { @activity_1.merge(@activity_2) }.to change(Activity, :count).by(-1)
    end

    it "should not destroy the second activity" do
      @activity_1.merge(@activity_2)
      expect(Activity.last).to eq(@activity_2)
    end

    it "should not change a users number of activities (if she doesn't have both)" do
      expect { @activity_1.merge(@activity_2) }.to change(@user_1.activities, :count).by(0)
    end

    it "should change a users number of activities (if she has both)" do
      @user_1.activities << @activity_2
      expect { @activity_1.merge(@activity_2) }.to change(@user_1.activities, :count).by(-1)
    end
  end
end
