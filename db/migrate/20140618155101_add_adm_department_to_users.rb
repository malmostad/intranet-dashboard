class AddAdmDepartmentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :adm_department, :string
  end
end
