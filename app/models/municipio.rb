class Municipio < ActiveRecord::Base
  belongs_to :estado
  attr_accessible :nombre
end
