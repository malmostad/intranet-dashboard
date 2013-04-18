class CreateUserAgents < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.references :user
      t.boolean :remember_me, default: false
      t.string :remember_me_hash
      t.string :user_agent_tag
      t.timestamps
    end
    add_index :user_agents, [ :id, :user_id ], :unique => true

    remove_column :users, :remember_me_hash
    remove_column :users, :remember_me_id
    remove_column :users, :remember_me
    remove_column :users, :salt
  end
end
