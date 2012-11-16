class AddGrupoToCunas < ActiveRecord::Migration
  def self.up
    add_column :cunas, :grupo, :string
  end

  def self.down
    remove_column :cunas, :grupo
  end
end