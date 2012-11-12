class Organizacion < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :nombre_corto, :rif, :tolda_id
  belongs_to :tolda
  
  has_many :candidates
  accepts_nested_attributes_for :candidates
  
  has_many :cunas
  accepts_nested_attributes_for :cunas
  
  validates_presence_of :nombre, :nombre_corto, :rif, :tolda_id
end
