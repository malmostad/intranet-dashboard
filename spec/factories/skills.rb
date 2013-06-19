FactoryGirl.define do
  factory :skill do
    sequence(:name) { |n| "skill-#{n}" }
  end
end
