class CreateCandidatos < ActiveRecord::Migration
  def change
    create_table :candidatos do |t|
      t.references :vocero
      t.references :eleccion
      t.references :municipio
      t.references :tipo_cargo

      t.timestamps
    end
    remove_column :candidatos,:id
    execute "alter table candidatos add primary key(vocero_id,eleccion_id)"
    add_index :candidatos, :vocero_id
    add_index :candidatos, :eleccion_id
    add_index :candidatos, :municipio_id
    add_index :candidatos, :tipo_cargo_id
  end
end
# 
# 
# 
# class CreateStudents < ActiveRecord::Migration
#   def self.up
#     create_table :students do |t|
#       t.string :roll_no
#       t.string :name
#       t.integer :age
#       t. timestamps
#     end
#     remove_column :students,:id
#     execute “alter table students add primary key(roll_no,name)”
#   end
#   def self.down
#     drop_table :students
#   end
# end