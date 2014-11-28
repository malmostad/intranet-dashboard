class AddRequestsToGroupContacts < ActiveRecord::Migration
  def change
    add_column :group_contacts, :requests, :integer, default: 0
  end
end
