class AddLinkToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :link, :string
  end
end
