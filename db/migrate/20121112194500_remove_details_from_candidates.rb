class RemoveDetailsFromCandidates < ActiveRecord::Migration
  def up
    remove_column :candidates, :organization
    remove_column :candidates, :state
  end

  def down
    add_column :candidates, :state, :string
    add_column :candidates, :organization, :string
  end
end
