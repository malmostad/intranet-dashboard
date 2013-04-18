class ChangeColumnsOnUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :displayname
      t.string :company
      t.string :manager
      t.string :directreports
      t.boolean :remember_me, default: false
      t.string :remember_me_key
    end
    remove_column :users, :password_digest
  end
end
