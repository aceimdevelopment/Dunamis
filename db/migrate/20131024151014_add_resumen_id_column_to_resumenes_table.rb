class AddResumenIdColumnToResumenesTable < ActiveRecord::Migration
  def change
    change_table :resumenes do |t|
      t.references :resumen
    end
    add_index :resumenes, :resumen_id

  end
end
