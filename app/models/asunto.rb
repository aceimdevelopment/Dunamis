class Asunto < ActiveRecord::Base
  attr_accessible :descripcion, :nombre
  
  has_many :temas
  accepts_nested_attributes_for :temas
  
  has_many :informes_asuntos
  accepts_nested_attributes_for :informes_asuntos, :dependent => :destroy
  
  
end
