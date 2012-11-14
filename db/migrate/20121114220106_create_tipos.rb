class CreateTipos < ActiveRecord::Migration
  def change
    create_table :tipos do |t|
      t.string :nombre, :null => false
      t.string :descripcion

      t.timestamps
    end
    add_index :tipos, :nombre, :unique => true
  end
end