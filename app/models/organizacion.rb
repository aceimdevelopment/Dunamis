class Organizacion < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :nombre_corto, :rif, :tolda_id
  belongs_to :tolda
  
  has_many :candidates
  accepts_nested_attributes_for :candidates
  
  validates_presence_of :nombre, :nombre_corto, :rif, :tolda_id
end
