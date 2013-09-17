class AddColumnTipoCargoToVocero < ActiveRecord::Migration
  def change
    change_table :voceros do |t|
      t.references :tipo_cargo
    end
    add_index :voceros, :tipo_cargo_id

  end
end
