class Informe < ActiveRecord::Base
  attr_accessible :fecha, :resumen
  
  has_many :resumenes
  accepts_nested_attributes_for :resumenes
end
