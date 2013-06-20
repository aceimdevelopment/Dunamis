class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
  end
end
