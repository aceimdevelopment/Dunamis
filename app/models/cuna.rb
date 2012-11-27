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
  
  # scope :organizacion, lambda {|name| where(["name ILIKE ? OR aliases ILIKE ?","%#{name}%","%#{name}%"])}
  scope :par_opo, joins(:organizacion).where('tolda_id = ? AND tipo_id = ?', 1, 1)
  scope :gob_opo, joins(:organizacion).where('tolda_id = ? AND tipo_id = ?', 2, 2)
  scope :gob_ch, joins(:organizacion).where('tolda_id = ? AND tipo_id = ?', 2, 2)
  scope :par_ch, joins(:organizacion).where('tolda_id = ? AND tipo_id = ?', 2, 1)
  
  scope :con_apariciones, joins(:apariciones)
  scope :apa2, includes(:apariciones)
  
  def candidates_names
    candidates_mames = ""
    candidates.each do |candidate|
      candidates_mames += "#{candidate.name} "
    end
    candidates_mames
    
  end

  def descripcion
    "#{sigecup_id} - #{nombre} - #{duracion} Seg."
  end
  
  def delete_candidates
    candidates.delete_all  
  end
  
  def self.delete_all_candidates
    Cuna.all.each { |c| c.delete_candidates }
  end
end