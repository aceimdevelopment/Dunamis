class CreateInformesTemas < ActiveRecord::Migration
  def change
    create_table :informes_temas do |t|
      t.references :informe, :null => false
      t.references :tema, :null => false
      t.integer :orden

      t.timestamps
    end
    add_index(:informes_temas, [:informe_id, :tema_id], :unique => true)
  end
end