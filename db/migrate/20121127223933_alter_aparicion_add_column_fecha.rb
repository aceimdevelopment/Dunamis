class AlterAparicionAddColumnFecha < ActiveRecord::Migration
  def self.up
    add_column :apariciones, :fecha, :date
  end

  def self.down
    remove_column :apariciones, :fecha
  end
end