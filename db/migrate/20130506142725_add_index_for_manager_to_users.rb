class AddIndexForManagerToUsers < ActiveRecord::Migration
  def change
    add_index :users, :manager_id
  end
end
