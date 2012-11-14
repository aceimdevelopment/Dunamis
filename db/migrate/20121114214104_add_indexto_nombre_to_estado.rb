class AddIndextoNombreToEstado < ActiveRecord::Migration
  def self.up
    add_index :estados, :nombre, :unique => true
  end

  def self.down
    remove_index :estados, :nombre
  end
end