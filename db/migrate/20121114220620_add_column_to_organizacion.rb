class AddColumnToOrganizacion < ActiveRecord::Migration
  def self.up
    add_column :organizaciones, :tipo_id, :integer
  end

  def self.down
    remove_column :organizaciones, :tipo_id
  end
end