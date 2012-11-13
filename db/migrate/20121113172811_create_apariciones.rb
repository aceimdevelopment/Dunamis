class CreateApariciones < ActiveRecord::Migration
  def change
    create_table :apariciones, :id => false do |t|
      t.integer :cuna_id, :null => false
      t.time :momento, :null => false
      t.integer :canal_id, :null => false

      t.timestamps
    end
  end
end

