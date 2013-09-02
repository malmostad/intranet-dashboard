class AddCmgIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cmg_id, :string, default: "0"
  end
end
