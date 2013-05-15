class AddDepartmentToUser < ActiveRecord::Migration
  def change
    add_column :users, :department, :string
  end
end
