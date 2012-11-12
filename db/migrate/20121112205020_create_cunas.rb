class CreateCunas < ActiveRecord::Migration
  def change
    create_table :cunas do |t|
      t.string :sigecup_id
      t.date :sigecup_creacion
      t.integer :duracion
      t.integer :ordanizacion_id
      t.integer :candidate_id
      t.string :video

      t.timestamps
    end
  end
end
