class Asunto < ActiveRecord::Base
  attr_accessible :descripcion, :nombre
  
  has_many :temas
  accepts_nested_attributes_for :temas
  
end
