class AddIndexToCunas < ActiveRecord::Migration
  def self.up
    add_index :cunas, :nombre, :unique => true
  end

  def self.down
    remove_index :cunas, :nombre
  end
end