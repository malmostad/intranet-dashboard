FactoryGirl.define do
  factory :api_app do
    sequence(:name) { |n| "api_app-#{n}" }
    contact 'jane.doe@example.com'
    ip_address '127.0.0.1'
  end
end
