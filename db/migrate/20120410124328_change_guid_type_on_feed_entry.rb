class ChangeGuidTypeOnFeedEntry < ActiveRecord::Migration
  def up
    change_column :feed_entries, :guid, :text, :limit => 2.kilobytes
  end
  def down
    change_column :feed_entries, :guid, :string
  end
end
