class Aparicion < ActiveRecord::Base
  attr_accessible :canal_id, :cuna_id, :momento
  
  belongs_to :cuna
  belongs_to :canal
  
  set_primary_keys :canal_id, :cuna_id, :momento
  validates_presence_of :canal_id, :cuna_id, :momento
end
