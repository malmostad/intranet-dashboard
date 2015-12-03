class ChangeTypeForTitleOnFeedEntries < ActiveRecord::Migration
  def up
    change_column :feed_entries, :title, :text
  end
  def down
    change_column :feed_entries, :title, :string
  end
end
