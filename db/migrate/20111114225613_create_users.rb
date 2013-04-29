class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :department
      t.string :phone
      t.string :cell_phone
      t.string :title
      t.text :short_bio
      t.string :status_message

      t.timestamps
    end
    add_index :users, :username, :unique => true
  end
end
