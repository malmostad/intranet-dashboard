class RemoveFetchedGravatarFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :fetched_gravatar
  end
end
