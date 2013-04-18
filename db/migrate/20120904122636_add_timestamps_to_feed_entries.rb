class AddTimestampsToFeedEntries < ActiveRecord::Migration
  def change
    add_timestamps :feed_entries
  end
end
