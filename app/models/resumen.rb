class Resumen < ActiveRecord::Base
  belongs_to :vocero
  belongs_to :informe
  attr_accessible :contenido, :titulo
end
