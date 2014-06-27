class CreateInformesAsuntos < ActiveRecord::Migration
  def change
    create_table :informes_asuntos do |t|
      t.references :informe, :null => false
      t.references :asunto, :null => false
      t.integer :orden

      t.timestamps
    end
    add_index(:informes_asuntos, [:informe_id, :asunto_id], :unique => true)
  end
end
