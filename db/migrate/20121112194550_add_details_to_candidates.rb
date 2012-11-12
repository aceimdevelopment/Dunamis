class AddDetailsToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :organizacion_id, :integer
    add_column :candidates, :estado_id, :integer
  end
end
