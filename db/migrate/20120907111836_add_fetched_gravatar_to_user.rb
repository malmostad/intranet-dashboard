class AddFetchedGravatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :fetched_gravatar, :boolean, default: false
  end
end
