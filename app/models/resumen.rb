class Resumen < ActiveRecord::Base
  belongs_to :vocero
  belongs_to :informe
  belongs_to :tema
  
  has_many :notas
  accepts_nested_attributes_for :notas
  
  attr_accessible :contenido, :titulo
end
