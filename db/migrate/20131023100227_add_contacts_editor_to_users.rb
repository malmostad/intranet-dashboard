class AddContactsEditorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contacts_editor, :boolean, default: false
  end
end
