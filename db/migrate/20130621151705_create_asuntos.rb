class CreateAsuntos < ActiveRecord::Migration
  def change
    create_table :asuntos do |t|
      t.text :nombre
      t.text :descripcion

      t.timestamps
    end
  end
end
