class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.string :category
      t.string :targeting
      t.integer :recent_failures, :default => 0
      t.integer :total_failures, :default => 0
      t.timestamps
    end
  end
end
