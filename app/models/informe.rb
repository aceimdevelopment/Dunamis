class Informe < ActiveRecord::Base
  attr_accessible :fecha, :resumen, :autor, :tema, :titulo
  
  has_many :resumenes
  accepts_nested_attributes_for :resumenes
  
end
