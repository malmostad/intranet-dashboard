class AddPostaddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :district, :string
    add_column :users, :post_code, :string
    add_column :users, :postal_town, :string
  end
end
