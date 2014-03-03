class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.belongs_to :activity
      t.belongs_to :user

      t.timestamps
    end
    add_index :user_activities, :activity_id
    add_index :user_activities, :user_id
  end
end
