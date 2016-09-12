class Informe < ActiveRecord::Base
  attr_accessible :fecha, :resumen, :autor, :tema, :titulo
  
  has_many :resumenes, :dependent => :destroy
  accepts_nested_attributes_for :resumenes

  has_many :informes_temas, :dependent => :destroy
  accepts_nested_attributes_for :informes_temas
  
  # has_and_belongs_to_many :temas, :join_table => "informes_temas"
  
end
