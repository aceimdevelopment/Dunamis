class AddEstadoAndMunicipioToOrganizacion < ActiveRecord::Migration
  def change
    change_table :organizaciones do |t|
      t.references :estado
      t.references :municipio
    end
    add_index :organizaciones, :estado_id
    add_index :organizaciones, :municipio_id
  end
end
