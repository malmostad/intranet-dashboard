# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user-#{n}" }
    first_name 'First'
    last_name 'Last'
    roles {
      Role::CATEGORIES.keys.map { |c|
        FactoryGirl.create(:role, category: c)
      }
    }
    sequence(:email) { |n| "user-#{n}@example.org" }
    sequence(:displayname) { |n| "First-#{n} Last-#{n}" }
    last_login Time.now
  end
end
