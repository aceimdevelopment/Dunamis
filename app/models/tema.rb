class Tema < ActiveRecord::Base
  validates_presence_of :asunto_id
  attr_accessible :descripcion, :nombre, :asunto_id
  belongs_to :asunto
  
  def full_descripcion
    
    "#{asunto.nombre} - "+"#{nombre}"
    
  end
  
end
