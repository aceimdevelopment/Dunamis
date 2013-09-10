class Municipio < ActiveRecord::Base
  belongs_to :estado
  attr_accessible :nombre, :estado_id
  
  has_many :candidatos
  accepts_nested_attributes_for :candidatos

end
