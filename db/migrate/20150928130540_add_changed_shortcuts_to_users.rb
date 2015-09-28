class AddChangedShortcutsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :changed_shortcuts, :boolean, default: false
  end
end
