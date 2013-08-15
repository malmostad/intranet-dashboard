class AddCmgIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cmg_id, :string
  end
end
