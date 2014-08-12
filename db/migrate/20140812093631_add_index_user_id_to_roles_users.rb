class AddIndexUserIdToRolesUsers < ActiveRecord::Migration
  def change
    add_index :roles_users, :user_id
  end
end
