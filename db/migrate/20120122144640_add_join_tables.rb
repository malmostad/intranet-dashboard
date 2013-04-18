class AddJoinTables < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.references :role
      t.references :user
      t.timestamps
    end
    add_index :roles_users, [ :role_id, :user_id ], :unique => true, :name => :index_roles_users

    create_table :roles_shortcuts, :id => false do |t|
      t.references :role
      t.references :shortcut
      t.timestamps
    end
    add_index :roles_shortcuts, [ :role_id, :shortcut_id ], :unique => true, :name => :index_roles_shortcuts

    create_table :feeds_roles, :id => false do |t|
      t.references :feed
      t.references :role
      t.timestamps
    end
    add_index :feeds_roles, [ :feed_id, :role_id ], :unique => true, :name => :index_feeds_roles

    create_table :feeds_users, :id => false do |t|
      t.references :feed
      t.references :user
      t.timestamps
    end
    add_index :feeds_users, [ :feed_id, :user_id ], :unique => true, :name => :index_feeds_user
  end
end
