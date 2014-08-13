class AddIndexFeedIdToFeedsRoles < ActiveRecord::Migration
  def change
    add_index :feeds_roles, :role_id
  end
end
