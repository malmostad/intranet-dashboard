class ChangeColumnOnFeeds < ActiveRecord::Migration
  def change
    rename_column :feeds, :published_at, :fetched_at
    remove_column :feeds, :etag
  end
end
