class CreateApiApps < ActiveRecord::Migration
  def change
    create_table :api_apps do |t|
      t.string :name
      t.string :contact
      t.string :app_token
      t.string :ip_address
      t.string :password_digest

      t.timestamps
    end
    add_index :api_apps, :app_token
  end
end
