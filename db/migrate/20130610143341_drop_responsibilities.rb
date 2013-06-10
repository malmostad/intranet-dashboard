class DropResponsibilities < ActiveRecord::Migration
  def up
    drop_table :responsibilities
  end
end
