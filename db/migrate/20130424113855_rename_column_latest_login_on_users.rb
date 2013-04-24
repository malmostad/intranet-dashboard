class RenameColumnLatestLoginOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :latest_login, :last_login
  end
end
