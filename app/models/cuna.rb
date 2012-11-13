class Cuna < ActiveRecord::Base
  attr_accessible :candidate_id, :duracion, :organizacion_id, :sigecup_creacion, :sigecup_id, :video
  
  belongs_to :organizacion
  
  belongs_to :candidate
  # has_and_belongs_to_many :candidates
  # accepts_nested_attributes_for :candidates
  
  validates_presence_of :duracion, :organizacion_id, :sigecup_id, :sigecup_creacion
  
end
