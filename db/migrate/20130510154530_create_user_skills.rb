class CreateUserSkills < ActiveRecord::Migration
  def change
    create_table :user_skills do |t|
      t.belongs_to :skill
      t.belongs_to :user

      t.timestamps
    end
    add_index :user_skills, :skill_id
    add_index :user_skills, :user_id
  end
end
