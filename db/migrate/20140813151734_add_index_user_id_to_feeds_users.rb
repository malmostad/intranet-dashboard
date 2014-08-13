class AddIndexUserIdToFeedsUsers < ActiveRecord::Migration
  def change
    add_index :feeds_users, :user_id
  end
end
