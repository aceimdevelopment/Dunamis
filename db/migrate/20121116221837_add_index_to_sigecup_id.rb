class AddIndexToSigecupId < ActiveRecord::Migration
  def self.up
    add_index :cunas, :sigecup_id, :unique => true
  end

  def self.down
    remove_index :cunas, :sigecup_id 
  end
end