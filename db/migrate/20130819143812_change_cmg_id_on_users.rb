class ChangeCmgIdOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :cmg_id, :string, default: "0"
  end

  def down
    change_column :users, :cmg_id, :string
  end
end
