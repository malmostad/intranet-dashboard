class ChangeUrLTypeOnFeed < ActiveRecord::Migration
  def up
    change_column :feeds, :url, :text, :limit => 2.kilobytes
    change_column :feeds, :feed_url, :text, :limit => 2.kilobytes
  end
  def down
    change_column :feeds, :url, :string
    change_column :feeds, :feed_url, :string
  end
end
