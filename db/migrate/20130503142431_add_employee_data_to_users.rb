class AddEmployeeDataToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :early_adopter
      t.string :business_card_title
      t.string :twitter
      t.string :skype
      t.text :private_bio
      t.rename :short_bio, :professional_bio
      t.rename :is_admin, :admin
      t.remove :manager
      t.remove :directreports
      t.integer :manager_id
    end
  end
end
