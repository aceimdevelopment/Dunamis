class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.text :url
      t.text :nombre
      t.text :descripcion
      t.text :logo

      t.timestamps
    end
  end
end
