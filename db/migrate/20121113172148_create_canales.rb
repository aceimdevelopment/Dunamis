class CreateCanales < ActiveRecord::Migration
  def change
    create_table :canales do |t|
      t.string :nombre
      t.string :siglas

      t.timestamps
    end
  end
end
