class AddCombinedFeedStreamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :combined_feed_stream, :boolean,  default: false
  end
end
