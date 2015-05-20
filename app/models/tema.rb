class Tema < ActiveRecord::Base
  validates_presence_of :asunto_id
  attr_accessible :descripcion, :nombre, :asunto_id
  belongs_to :asunto
  
  has_many :resumenes
  accepts_nested_attributes_for :resumenes
  validates :nombre, uniqueness: { scope: :asunto_id, case_sensitive: false}
  
  has_many :informes_temas
  accepts_nested_attributes_for :informes_temas

  has_many :alertas
  accepts_nested_attributes_for :alertas
  
  # has_and_belongs_to_many :informes, :join_table => "informes_temas"
  
  def full_descripcion    
    "#{asunto.nombre} - "+"#{nombre}"    
  end
  
end
