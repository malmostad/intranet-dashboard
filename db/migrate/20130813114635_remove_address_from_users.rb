class RemoveAddressFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :postal_town
    remove_column :users, :post_code
    remove_column :users, :neighborhood
  end

  def down
    add_column :users, :neighborhood, :string
    add_column :users, :post_code, :string
    add_column :users, :postal_town, :string
  end
end
