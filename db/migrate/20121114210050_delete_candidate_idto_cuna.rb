class DeleteCandidateIdtoCuna < ActiveRecord::Migration
  def self.up
    remove_column :cunas, :candidate_id
  end

  def self.down
    add_column :cunas, :candidate_id, :integer, :null => false
  end
end
