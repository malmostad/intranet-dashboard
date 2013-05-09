class Language < ActiveRecord::Base
  attr_accessible :name
  has_many :user_languages
  has_many :users, through: :user_languages

  before_save do
    self.name.downcase!
  end
end
