class AddColumnToCuna < ActiveRecord::Migration
  def self.up
    add_column :cunas, :nombre, :string, :null => false, :unique => true
  end

  def self.down
    remove_column :cunas, :nombre
  end
end