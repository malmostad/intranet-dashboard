class AddChecksumToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :checksum, :string
  end
end
