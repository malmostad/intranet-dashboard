class RemoveBusinessCardTitleFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :business_card_title
  end

  def down
    add_column :users, :business_card_title, :string
  end
end
