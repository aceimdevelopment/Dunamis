class AlterNotaTableAddColumnImagen < ActiveRecord::Migration
  def change
    change_table :notas do |t|
      t.string :imagen
      
    end
  end
end
