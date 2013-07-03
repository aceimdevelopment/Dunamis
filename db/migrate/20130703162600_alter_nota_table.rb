class AlterNotaTable < ActiveRecord::Migration
  def self.up
    remove_column :notas, :asunto_id
    remove_column :notas, :tema_id
  end

  def self.down
  end
end
