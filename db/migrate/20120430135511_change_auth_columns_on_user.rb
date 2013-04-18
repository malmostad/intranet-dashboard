class ChangeAuthColumnsOnUser < ActiveRecord::Migration
  def up
    rename_column :users, :auth_token, :remember_me_hash
    add_column :users, :remember_me_id, :string
    add_column :users, :remember_me, :boolean
  end

  def down
    rename_column :users, :remember_me_hash, :auth_token
    remove_column :users, :remember_me_id
    remove_column :users, :remember_me
  end
end
