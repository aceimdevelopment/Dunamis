class Aparicion < ActiveRecord::Base
  attr_accessible :canal_id, :cuna_id, :momento
  
  belongs_to :cuna
  belongs_to :canal
  
  set_primary_keys :canal_id, :cuna_id, :momento
  validates_presence_of :canal_id, :cuna_id, :momento
  
  # scope :with_name, lambda {|name| where(["name ILIKE ? OR aliases ILIKE ?","%#{name}%","%#{name}%"])}
  # 
  # scope :organizacion, lambda {|name| where(["name ILIKE ? OR aliases ILIKE ?","%#{name}%","%#{name}%"])}
  # 
  # scope :gob_opo, joins(:cunas).where('cunas.id = ?', 'value')
  
  def fecha
    momento.to_date
  end
  
  
end
