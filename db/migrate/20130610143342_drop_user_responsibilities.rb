class DropUserResponsibilities < ActiveRecord::Migration
  def up
    drop_table :user_responsibilities
  end
end
