class AddColumnsToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :image_url, :string
    add_column :feed_entries, :image_url_medium, :string
    add_column :feed_entries, :image_url_large, :string
    add_column :feed_entries, :url, :string
    add_column :feed_entries, :title, :string
    add_column :feed_entries, :summary, :text
    add_column :feed_entries, :count_comments, :integer
    remove_column :feed_entries, :full
  end
end
