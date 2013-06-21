class CreateResumenes < ActiveRecord::Migration
  def change
    create_table :resumenes do |t|
      t.text :titulo
      t.text :contenido
      t.references :vocero
      t.references :informe

      t.timestamps
    end
    add_index :resumenes, :vocero_id
    add_index :resumenes, :informe_id
  end
end
