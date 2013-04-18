class AddEtagAndPublishedAtToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :etag, :string
    add_column :feeds, :published_at, :datetime
  end
end
