class RemoveTargetingFromFeedsAndShortcuts < ActiveRecord::Migration
  def up
    remove_column :feeds, :targeting
    remove_column :shortcuts, :targeting
  end
  def down
    add_column :feeds, :targeting, :string
    add_column :shortcuts, :targeting, :string
  end
end
