class CreateCandidatesCunas < ActiveRecord::Migration
  def change
    create_table :candidates_cunas, :id => false do |t|
      t.references :candidate, :null => false
      t.references :cuna, :null => false
    end

    # Adding the index can massively speed up join tables. Don't use the
    # unique if you allow duplicates.
    add_index(:candidates_cunas, [:candidate_id, :cuna_id], :unique => true)
  end
end
