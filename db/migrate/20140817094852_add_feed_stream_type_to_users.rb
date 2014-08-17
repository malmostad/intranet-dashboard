class AddFeedStreamTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :feed_stream_type, :string, default: 'categorized'
  end
end