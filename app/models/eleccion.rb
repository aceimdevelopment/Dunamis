class Eleccion < ActiveRecord::Base
  attr_accessible :ano, :fecha, :nombre
  
  has_many :candidatos
  accepts_nested_attributes_for :candidatos
  
  def descripcion
    "#{nombre} - #{ano}"
  end
  
end
