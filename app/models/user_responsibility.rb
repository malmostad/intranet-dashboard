class UserResponsibility < ActiveRecord::Base
  belongs_to :responsibility
  belongs_to :user
end
