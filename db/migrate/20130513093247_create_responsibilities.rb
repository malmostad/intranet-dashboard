class CreateResponsibilities < ActiveRecord::Migration
  def change
    create_table :responsibilities do |t|
      t.string :name

      t.timestamps
    end
    add_index :responsibilities, :name
  end
end
