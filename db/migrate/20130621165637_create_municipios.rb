class CreateMunicipios < ActiveRecord::Migration
  def change
    create_table :municipios do |t|
      t.references :estado
      t.text :nombre

      t.timestamps
    end
    add_index :municipios, :estado_id
  end
end
