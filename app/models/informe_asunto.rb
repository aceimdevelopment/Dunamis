class InformeAsunto < ActiveRecord::Base
  attr_accessible :informe_id, :orden, :asunto_id
  
  belongs_to :informe
  belongs_to :asunto
  
  validates :informe_id, :uniqueness => {:scope => :asunto_id}
  
  # scope :encontrar_asunto, -> asunto_id {where(:asunto_id => asunto_id).limit(1).first}
  
  
end
