class InformeTema < ActiveRecord::Base
  attr_accessible :informe_id, :orden, :tema_id
  
  belongs_to :informe
  belongs_to :tema
  
  validates :informe_id, :uniqueness => {:scope => :tema_id}
  
end
