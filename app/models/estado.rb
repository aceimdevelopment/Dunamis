class Estado < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :nombre_corto
  validates_presence_of :nombre
end
