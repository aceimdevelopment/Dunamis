class AddOrganizacionIdToCunas < ActiveRecord::Migration
  def change
    add_column :cunas, :organizacion_id, :integer
  end
end
