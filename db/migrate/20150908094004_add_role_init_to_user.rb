class AddRoleInitToUser < ActiveRecord::Migration
  def change
    add_column :users, :departments_setuped, :boolean, default: false
    add_column :users, :working_fields_setuped, :boolean, default: false
  end
end
