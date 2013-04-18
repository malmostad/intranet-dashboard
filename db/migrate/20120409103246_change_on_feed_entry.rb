class ChangeOnFeedEntry < ActiveRecord::Migration
  def up
    rename_column :feed_entries, :entry, :full
    change_column :feed_entries, :full, :text, :limit => 500.kilobytes
  end
  def down
    change_column :feed_entries, :entry, :string
    rename_column :feed_entries, :full, :entry
  end
end
