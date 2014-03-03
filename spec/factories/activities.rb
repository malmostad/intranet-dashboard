FactoryGirl.define do
  factory :activity do
    sequence(:name) { |n| "activity-#{n}" }
  end
end
