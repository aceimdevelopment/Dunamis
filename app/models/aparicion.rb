class Aparicion < ActiveRecord::Base
  attr_accessible :canal_id, :cuna_id, :momento
  
  set_primary_keys :canal_id, :cuna_id, :momento
end
