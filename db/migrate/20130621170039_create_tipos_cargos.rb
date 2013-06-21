class CreateTiposCargos < ActiveRecord::Migration
  def change
    create_table :tipos_cargos do |t|
      t.text :nombre
      t.text :nombre_corto

      t.timestamps
    end
  end
end
