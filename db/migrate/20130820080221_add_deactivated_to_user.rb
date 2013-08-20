class AddDeactivatedToUser < ActiveRecord::Migration
  def change
    add_column :users, :deactivated, :boolean, default: false
    add_column :users, :deactivated_at, :datetime
  end
end
