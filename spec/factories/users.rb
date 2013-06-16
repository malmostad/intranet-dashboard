# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user-#{n}" }
    first_name 'First'
    last_name 'Last'
    roles { 1.upto(2).map {|n| FactoryGirl.create(:role, category: Role::CATEGORIES.keys[n % Role::CATEGORIES.size]) } }
    sequence(:email) { |n| "user-#{n}@example.org" }
    sequence(:displayname) { |n| "First-#{n} Last-#{n}" }
    last_login Time.now
  end

  factory :user_with_status_message, parent: :user do
    status_message 'It’s work, all that matters is work'
    status_message_updated_at Time.now
  end

  factory :add_collagues, parent: :user do
  end
end

