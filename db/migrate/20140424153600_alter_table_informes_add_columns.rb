class AlterTableInformesAddColumns < ActiveRecord::Migration
  def change
    change_table :informes do |t|
       t.string :titulo
       t.string :autor
       t.string :tema
    end
  end
end
