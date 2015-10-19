class AddSelectedRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :department_selected, :boolean, default: false
    add_column :users, :working_field_selected, :boolean, default: false
  end
end
