class AddColumnTemaIdToResumenes < ActiveRecord::Migration
  def change
    change_table :resumenes do |t|
      t.references :tema, :null => false
    end
    add_index :resumenes, :tema_id
  end
end