class RemoveTimestampsFromJoinTables < ActiveRecord::Migration
  def up
    remove_column :roles_users, :created_at
    remove_column :roles_users, :updated_at
    remove_column :roles_shortcuts, :created_at
    remove_column :roles_shortcuts, :updated_at
    remove_column :feeds_roles, :created_at
    remove_column :feeds_roles, :updated_at
    remove_column :feeds_users, :created_at
    remove_column :feeds_users, :updated_at
    remove_column :feed_entries, :created_at
    remove_column :feed_entries, :updated_at
  end

  def down
    add_timestamps :roles_users
    add_timestamps :roles_shortcuts
    add_timestamps :feeds_roles
    add_timestamps :feeds_users
    add_timestamps :feed_entries
  end
end
