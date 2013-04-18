class AddRecentSkipsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :recent_skips, :integer, default: 0
  end
end
