class ChangeColumnTypeDirectreportsOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :directreports, :text
  end

  def down
    change_column :users, :directreports, :string
  end
end
