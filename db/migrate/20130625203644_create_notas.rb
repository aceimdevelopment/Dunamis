class CreateNotas < ActiveRecord::Migration
  def change
    create_table :notas do |t|
      t.text :titulo, :null => false
      t.text :contenido, :null => false
      t.references :tipo_nota, :null => false
      t.references :tema, :null => false
      t.references :asunto, :null => false
      t.text :url, :null => false, :unique => true
      t.references :website, :null => false
      t.references :resume, :null => false

      t.timestamps
    end
    add_index :notas, :tipo_nota_id
    add_index :notas, :tema_id
    add_index :notas, :asunto_id
    add_index :notas, :website_id
    add_index :notas, :resume_id
  end
end
