class UserActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user
end
