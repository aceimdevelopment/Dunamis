class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name, :null => false
      t.string :organization, :null => false
      t.string :state, :null => false
      t.string :description
      t.string :foto

      t.timestamps
    end
  end
end
