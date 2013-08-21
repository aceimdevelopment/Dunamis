class CreateTiposWebnotas < ActiveRecord::Migration
  def change
    create_table :tipos_webnotas do |t|
      t.string :div_nota
      t.string :div_titulo
      t.string :div_fecha
      t.string :div_contenido
      t.string :div_imagen
      t.references :website

      t.timestamps
    end
    add_index :tipos_webnotas, :website_id
  end
end
