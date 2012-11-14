class Tipo < ActiveRecord::Base
  attr_accessible :descripcion, :nombre
    has_many :organizaciones
end
