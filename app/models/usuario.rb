class Usuario < ActiveRecord::Base
  attr_accessible :contrasena, :correo, :nombre, :nombre_sesion, :contrasena_confirmation
  validates_confirmation_of :contrasena
end
