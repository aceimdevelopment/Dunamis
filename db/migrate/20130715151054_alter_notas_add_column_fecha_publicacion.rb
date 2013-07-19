class AlterNotasAddColumnFechaPublicacion < ActiveRecord::Migration
  def change
    change_table :notas do |t|
      t.string :fecha_publicacion
      
    end
  end
end
