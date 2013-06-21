class CreateVoceros < ActiveRecord::Migration
  def change
    create_table :voceros do |t|
      t.references :organizacion
      t.text :nombre
      t.text :foto
      t.text :descripcion

      t.timestamps
    end
    add_index :voceros, :organizacion_id
  end
end
