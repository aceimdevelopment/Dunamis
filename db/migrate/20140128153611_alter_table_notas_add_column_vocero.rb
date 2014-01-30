class AlterTableNotasAddColumnVocero < ActiveRecord::Migration
  def change
    change_table :notas do |t|
      t.references :vocero
    end
    add_index :notas, :vocero_id

  end
end
