class Municipio < ActiveRecord::Base
  belongs_to :estado
  attr_accessible :nombre, :estado_id
  
  has_many :candidatos
  accepts_nested_attributes_for :candidatos
  
  validates :nombre, uniqueness: { scope: :estado_id, case_sensitive: false}
  
  def descripcion
    "#{estado.nombre} - #{nombre}"
  end

end
