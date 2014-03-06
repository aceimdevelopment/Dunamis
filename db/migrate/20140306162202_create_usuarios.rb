class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :nombre_sesion
      t.string :contrasena
      t.string :correo

      t.timestamps
    end
  end
end
