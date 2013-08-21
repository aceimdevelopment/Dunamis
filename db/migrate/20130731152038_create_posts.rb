class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :nombre
      t.references :website

      t.timestamps
    end
    add_index :posts, :website_id
  end
end
