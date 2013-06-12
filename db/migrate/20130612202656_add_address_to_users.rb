class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :room, :string
    add_column :users, :address, :string
    add_column :users, :post_code, :string
    add_column :users, :postal_town, :string
    add_column :users, :neighborhood, :string
    add_column :users, :geo_position_x, :integer
    add_column :users, :geo_position_y, :integer
  end
end
