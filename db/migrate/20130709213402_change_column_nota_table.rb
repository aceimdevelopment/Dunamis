class ChangeColumnNotaTable < ActiveRecord::Migration
  def change
    change_table :notas do |t|
      t.references :resumen, :null => false
      
    end
    remove_column :notas, :resume_id
    add_index :notas, :resumen_id
  end
end