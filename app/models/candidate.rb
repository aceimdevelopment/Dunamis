class Candidate < ActiveRecord::Base
  attr_accessible :description, :foto, :name, :organization, :state
  
  validates_presence_of :name, :organization, :state
  
end
