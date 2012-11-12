class RemoveOrdanizacionIdFromCunas < ActiveRecord::Migration
  def up
    remove_column :cunas, :ordanizacion_id
  end

  def down
    add_column :cunas, :ordanizacion_id, :integer
  end
end
