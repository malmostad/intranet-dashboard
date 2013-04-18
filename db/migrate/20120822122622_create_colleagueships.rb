class CreateColleagueships < ActiveRecord::Migration
  def change
    create_table :colleagueships do |t|
      t.integer :user_id
      t.integer :colleague_id

      t.timestamps
    end
    add_index :colleagueships, [:user_id, :colleague_id], :unique => true
  end
end
