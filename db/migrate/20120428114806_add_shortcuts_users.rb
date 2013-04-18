class AddShortcutsUsers < ActiveRecord::Migration
  def change
    create_table :shortcuts_users, :id => false do |t|
      t.references :shortcut
      t.references :user
    end
    add_index :shortcuts_users, [ :shortcut_id, :user_id ], :unique => true, :name => :index_shortcuts_user
  end
end
