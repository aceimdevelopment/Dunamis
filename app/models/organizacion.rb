class Organizacion < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :nombre_corto, :rif
end
