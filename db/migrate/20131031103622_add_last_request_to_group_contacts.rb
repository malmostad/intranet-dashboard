class AddLastRequestToGroupContacts < ActiveRecord::Migration
  def change
    add_column :group_contacts, :last_request, :datetime
    add_column :group_contacts, :last_request_by, :integer
  end
end
