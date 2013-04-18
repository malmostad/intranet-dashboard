class ChangeNamesOnFeed < ActiveRecord::Migration
  def change
    rename_column :feeds, :name, :title
    rename_column :feeds, :url, :feed_url
    rename_column :feeds, :link, :url
  end
end
