class AlterTemaTableAddColumn < ActiveRecord::Migration
  def change
    change_table :temas do |t|
      t.references :asunto, :null => false
    end
    add_index :temas, :asunto_id
  end
end