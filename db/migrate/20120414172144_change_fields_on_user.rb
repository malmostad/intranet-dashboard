class ChangeFieldsOnUser < ActiveRecord::Migration
  def change
    rename_column :users, :remember_me_key, :auth_token
    remove_column :users, :remember_me
    change_column :users, :is_admin, :boolean,  :null => false
  end
end
