class Vocero < ActiveRecord::Base
  belongs_to :organizacion
  belongs_to :tipo_cargo
  
  has_many :candidatos
  accepts_nested_attributes_for :candidatos
  
  attr_accessible :descripcion, :foto, :nombre, :organizacion_id, :tipo_cargo_id
  validates :nombre, uniqueness: { case_sensitive: false }
  
end
