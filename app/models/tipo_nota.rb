class TipoNota < ActiveRecord::Base
  attr_accessible :nombre
  
  has_many :notas
  accepts_nested_attributes_for :notas
end
