class AddAddStatusMessageUpdatedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :status_message_updated_at, :datetime, default: nil
  end
end
