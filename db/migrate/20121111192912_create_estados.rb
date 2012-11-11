class CreateEstados < ActiveRecord::Migration
  def change
    create_table :estados do |t|
      t.string :nombre
      t.string :descripcion
      t.string :nombre_corto

      t.timestamps
    end
  end
end
