class CreateTiposNotas < ActiveRecord::Migration
  def change
    create_table :tipos_notas do |t|
      t.text :nombre

      t.timestamps
    end
  end
end
