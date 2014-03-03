FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "project-#{n}" }
  end
end
