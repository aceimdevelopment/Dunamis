class Municipio < ActiveRecord::Base
  belongs_to :estado
  attr_accessible :nombre
  has_many :candidatos
  accepts_nested_attributes_for :candidatos

end
