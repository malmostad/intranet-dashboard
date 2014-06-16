class AddFieldsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :house_identifier
      t.string :physical_delivery_office_name
    end
  end
end
