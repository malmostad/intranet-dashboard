class CreateUserProjects < ActiveRecord::Migration
  def change
    create_table :user_projects do |t|
      t.belongs_to :project
      t.belongs_to :user

      t.timestamps
    end
    add_index :user_projects, :project_id
    add_index :user_projects, :user_id
  end
end
