FactoryGirl.define do
  factory :language do
    sequence(:name) { |n| "language-#{n}" }
  end
end
