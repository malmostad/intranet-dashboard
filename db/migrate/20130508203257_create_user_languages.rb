class CreateUserLanguages < ActiveRecord::Migration
  def change
    create_table :user_languages do |t|
      t.belongs_to :language
      t.belongs_to :user

      t.timestamps
    end
    add_index :user_languages, :language_id
    add_index :user_languages, :user_id
  end
end
