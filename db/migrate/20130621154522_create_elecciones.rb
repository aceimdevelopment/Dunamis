class CreateElecciones < ActiveRecord::Migration
  def change
    create_table :elecciones do |t|
      t.date :fecha
      t.text :nombre
      t.integer :ano

      t.timestamps
    end
  end
end
