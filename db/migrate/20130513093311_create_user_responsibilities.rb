class CreateUserResponsibilities < ActiveRecord::Migration
  def change
    create_table :user_responsibilities do |t|
      t.belongs_to :responsibility
      t.belongs_to :user

      t.timestamps
    end
    add_index :user_responsibilities, :responsibility_id
    add_index :user_responsibilities, :user_id
  end
end
