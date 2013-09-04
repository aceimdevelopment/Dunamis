class CreatePartidos < ActiveRecord::Migration
  def change
    create_table :partidos do |t|
      t.references :organizacion
      t.references :tolda

      t.timestamps
    end
    remove_column :partidos,:id
    execute "alter table partidos add primary key(organizacion_id,tolda_id)"
    add_index :partidos, :organizacion_id
    add_index :partidos, :tolda_id
  end
end
