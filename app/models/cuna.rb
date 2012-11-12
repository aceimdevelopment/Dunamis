class Cuna < ActiveRecord::Base
  attr_accessible :candidate_id, :duracion, :organizacion_id, :sigecup_creacion, :sigecup_id, :video
  
  belongs_to :organizacion
  
  has_many :candidates
  accepts_nested_attributes_for :candidates
  
end
