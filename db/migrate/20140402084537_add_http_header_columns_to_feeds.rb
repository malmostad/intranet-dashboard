class AddHttpHeaderColumnsToFeeds < ActiveRecord::Migration
  def change
    change_table :feeds do |t|
      t.string :etag
      t.datetime :last_modified
      t.remove :checksum
    end
  end
end
