class Alerta < ActiveRecord::Base
  attr_accessible :contenido, :resumen, :fecha, :tema_id, :tipo_alerta_id, :vocero_id
  
  belongs_to :tema,
  :class_name => 'Tema',
  :foreign_key => ['tema_id']
  accepts_nested_attributes_for :tema
  
  belongs_to :tipo_alerta,
  :class_name => 'TipoAlerta',
  :foreign_key => ['tipo_alerta_id']
  
  belongs_to :vocero,
  :class_name => 'Vocero',
  :foreign_key => ['vocero_id']

  validates_uniqueness_of :contenido

end
