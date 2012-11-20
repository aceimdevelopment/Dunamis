class Cuna < ActiveRecord::Base
  attr_accessible :candidate_id, :duracion, :organizacion_id, :sigecup_creacion, :sigecup_id, :video, :candidate_ids, :nombre
  
  belongs_to :organizacion
  
  has_many :apariciones
  accepts_nested_attributes_for :apariciones  
  # belongs_to :candidate
  has_and_belongs_to_many :candidates, :join_table => "candidates_cunas"
  # accepts_nested_attributes_for :candidates
  
  validates_presence_of :duracion, :organizacion_id, :sigecup_id, :sigecup_creacion
  validates :sigecup_id, :uniqueness => true
  
  def candidates_names
    candidates_mames = ""
    candidates.each do |candidate|
      candidates_mames += "#{candidate.name} "
    end
    candidates_mames
    
  end

  def descripcion
    "#{sigecup_id} - #{nombre}"
  end
  
  def delete_candidates
    candidates.delete_all  
  end
  
  def self.delete_all_candidates
    Cuna.all.each { |c| c.delete_candidates }
  end
end
