class AddLatestLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latest_login, :timestamp
  end
end
