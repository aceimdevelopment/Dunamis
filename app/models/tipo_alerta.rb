class TipoAlerta < ActiveRecord::Base
  attr_accessible :descripcion

  has_many :alertas
  accepts_nested_attributes_for :alertas
  
end
