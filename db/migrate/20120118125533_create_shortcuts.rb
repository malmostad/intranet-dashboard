class CreateShortcuts < ActiveRecord::Migration
  def change
    create_table :shortcuts do |t|
      t.string :name
      t.string :url
      t.string :targeting
      t.string :category
      t.timestamps
    end
  end
end
