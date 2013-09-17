class TipoCargo < ActiveRecord::Base
  attr_accessible :nombre, :nombre_corto
  validates_uniqueness_of :nombre
  
  has_many :voceros
  accepts_nested_attributes_for :voceros
  
end
