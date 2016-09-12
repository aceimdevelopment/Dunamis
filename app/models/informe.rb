class Informe < ActiveRecord::Base
  attr_accessible :fecha, :resumen, :autor, :tema, :titulo
  
  has_many :resumenes
  accepts_nested_attributes_for :resumenes, :dependent => :destroy

  has_many :informes_temas
  accepts_nested_attributes_for :informes_temas, :dependent => :destroy
  
  # has_and_belongs_to_many :temas, :join_table => "informes_temas"
  
end
