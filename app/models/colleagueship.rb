# -*- coding: utf-8 -*-

class Colleagueship < ActiveRecord::Base
  attr_accessible :colleague_id, :create, :destroy, :user_id

  belongs_to :user
  belongs_to :colleague, class_name: "User"

  validates :colleague_id, presence: true

  # Prevent duplicate entries of colleague_id and user_id
  validates :colleague_id, uniqueness: { scope: :user_id }

  def self.search(user, term, max = 20)
    User.where("(username LIKE ? OR
        first_name LIKE ? OR
        last_name LIKE ? OR
        concat_ws(' ', first_name, last_name) LIKE ? OR
        email LIKE ?) AND
        id NOT IN (?)",
        term, term, term, term, term, user.colleagues.map(&:id).push(user.id))
      .order(:first_name).limit(max)
  end
end
