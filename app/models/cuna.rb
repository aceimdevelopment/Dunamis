class Cuna < ActiveRecord::Base
  attr_accessible :candidate_id, :duracion, :organizacion_id, :sigecup_creacion, :sigecup_id, :video, :candidate_ids, :nombre
  
  belongs_to :organizacion
  
  # belongs_to :candidate
  has_and_belongs_to_many :candidates, :join_table => "candidates_cunas"
  # accepts_nested_attributes_for :candidates
  
  validates_presence_of :duracion, :organizacion_id, :sigecup_id, :sigecup_creacion
  
  def candidates_names
    candidates_mames = ""
    candidates.each do |candidate|
      candidates_mames += "#{candidate.name} "
    end
    candidates_mames
    
  end
  
end
