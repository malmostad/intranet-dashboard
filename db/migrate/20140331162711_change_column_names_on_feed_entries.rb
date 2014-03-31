class ChangeColumnNamesOnFeedEntries < ActiveRecord::Migration
  def change
    change_table :feed_entries do |t|
      t.rename :image_url, :image
      t.rename :image_url_medium, :image_medium
      t.rename :image_url_large, :image_large
      t.rename :published_at, :published
    end
  end
end
