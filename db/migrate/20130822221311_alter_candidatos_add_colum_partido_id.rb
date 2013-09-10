class AlterCandidatosAddColumPartidoId < ActiveRecord::Migration
  def change
    
    change_table :candidatos do |t|
      t.references :partido
    end
    add_index :candidatos, :partido_id
  end
end