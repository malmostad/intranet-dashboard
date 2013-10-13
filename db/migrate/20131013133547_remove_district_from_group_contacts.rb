class RemoveDistrictFromGroupContacts < ActiveRecord::Migration
  def up
    remove_column :group_contacts, :district
    remove_column :group_contacts, :geo_position_x
    remove_column :group_contacts, :geo_position_y
  end
  def down
    add_column :group_contacts, :district, :string
    add_column :group_contacts, :geo_position_x, :string
    add_column :group_contacts, :geo_position_y, :string
  end
end
