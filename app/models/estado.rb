class Estado < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :nombre_corto
  validates_presence_of :nombre, :nombre_corto
  
  has_many :candidates
  accepts_nested_attributes_for :candidates
  
  has_many :municipios
  accepts_nested_attributes_for :municipios
  
  
end
