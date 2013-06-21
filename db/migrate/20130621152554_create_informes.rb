class CreateInformes < ActiveRecord::Migration
  def change
    create_table :informes do |t|
      t.date :fecha
      t.text :resumen

      t.timestamps
    end
  end
end
