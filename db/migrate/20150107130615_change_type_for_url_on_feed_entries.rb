class ChangeTypeForUrlOnFeedEntries < ActiveRecord::Migration
  def up
    change_column :feed_entries, :url, :text
  end
  def down
    change_column :feed_entries, :url, :string
  end
end
