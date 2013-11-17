class AddLegacyDnToGroupContacts < ActiveRecord::Migration
  def change
    add_column :group_contacts, :legacy_dn, :string
  end
end