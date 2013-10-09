class AlterTemaIdInNota < ActiveRecord::Migration
  def up
    remove_column :resumenes, :tema_id
    change_table :resumenes do |t|
      t.references :tema
    end
    add_index :resumenes, :tema_id    
  end
  
  def down
    
  end
end