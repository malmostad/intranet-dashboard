class CreateGroupContacts < ActiveRecord::Migration
  def change
    create_table :group_contacts do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :cell_phone
      t.string :fax
      t.string :phone_hours
      t.string :homepage
      t.string :address
      t.string :zip_code
      t.string :postal_town
      t.string :geo_position_x
      t.string :geo_position_y
      t.string :district
      t.string :visitors_address
      t.string :visitors_address_zip_code
      t.string :visitors_address_postal_town
      t.string :visitors_address_geo_position_x
      t.string :visitors_address_geo_position_y
      t.string :visitors_district
      t.string :visiting_hours

      t.timestamps
    end
    add_index :group_contacts, :name, unique: true
  end
end
