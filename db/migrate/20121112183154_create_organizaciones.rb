class CreateOrganizaciones < ActiveRecord::Migration
  def change
    create_table :organizaciones do |t|
      t.string :nombre
      t.string :descripcion
      t.string :nombre_corto
      t.string :rif
      t.integer :tolda_id

      t.timestamps
    end
  end
end
