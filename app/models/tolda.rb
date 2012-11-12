class Tolda < ActiveRecord::Base
  attr_accessible :nombre
  has_many :organizaciones
  accepts_nested_attributes_for :organizaciones
end
