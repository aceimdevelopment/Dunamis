class AlterTableAddColumnOrden < ActiveRecord::Migration
  def change
    change_table :resumenes do |t|
       t.integer :orden
    end
    add_index :resumenes, :orden

  end
end
