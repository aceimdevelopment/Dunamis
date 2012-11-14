class AlterAparicionesAddIndex < ActiveRecord::Migration
  def self.up
    add_index :apariciones, [:canal_id, :cuna_id, :momento], :unique => true
  end

  def self.down
    remove_index :apariciones, [:canal_id, :cuna_id, :momento]
  end
end