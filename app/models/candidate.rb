class Candidate < ActiveRecord::Base
  attr_accessible :description, :foto, :name, :organizacion_id, :estado_id
  
  belongs_to :organizacion
  belongs_to :estado
  
  # has_many :cunas
  has_and_belongs_to_many :cunas, :join_table => "candidates_cunas"
  # accepts_nested_attributes_for :cunas
  
  validates_presence_of :name, :organizacion_id, :estado_id
  
end
