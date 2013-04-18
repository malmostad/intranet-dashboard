class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.text :entry
      t.datetime :published_at
      t.string :guid
      t.references :feed

      t.timestamps
    end
    add_index :feed_entries, :feed_id
  end
end
