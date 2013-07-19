class ChangeColumnResumenInNotaTable < ActiveRecord::Migration
  def change
    remove_column :notas, :resumen_id
    change_table :notas do |t|
      t.references :resumen
      
    end
    add_index :notas, :resumen_id
  end
end