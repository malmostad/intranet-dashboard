FactoryGirl.define do
  factory :group_contact do
    sequence(:name) { |n| "group_contact-#{n}" }
  end
end
