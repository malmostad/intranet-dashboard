class User < ActiveRecord::Base
  has_secure_password

  attr_protected :salt, :is_admin

  validates :username, :uniqueness => true, :length => { :minimum => 6 }
  validates :email, :uniqueness => true, :format => { :with => /^\S+@[\w\.]{2,}\.[a-z]{2,4}$/i }
  validates :password, :length => { :minimum => 6 }
  validates_confirmation_of :password

end
