class Partido < ActiveRecord::Base
  attr_accessible :organizacion_id,:tolda_id
  
  require 'composite_primary_keys'
  set_primary_keys :organizacion_id,:tolda_id
  
  validates_uniqueness_of [:organizacion_id,:tolda_id]
  
  belongs_to :organizacion
  belongs_to :tolda

  has_many :candidatos
  accepts_nested_attributes_for :candidatos
  
end
