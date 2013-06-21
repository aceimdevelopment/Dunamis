class Vocero < ActiveRecord::Base
  belongs_to :organizacion
  attr_accessible :descripcion, :foto, :nombre
end
