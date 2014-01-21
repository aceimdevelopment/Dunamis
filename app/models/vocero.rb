class Vocero < ActiveRecord::Base
  belongs_to :organizacion
  belongs_to :tipo_cargo
  
  has_many :candidatos
  accepts_nested_attributes_for :candidatos
  
  attr_accessible :descripcion, :foto, :nombre, :organizacion_id, :tipo_cargo_id
  validates :nombre, uniqueness: { case_sensitive: false }
  
  def sin_foto
    foto = "#{Rails.root}/images/sin_foto.png" if foto.blank? 
  end
  
  def descripcion_completa
    
    # foto = asset_path 'sin_foto.png' if foto.blank?
    "<img class='flag' src='#{foto}' style='max-width: 50px; max-height:50px;'/> #{nombre}"
  end   
  
  
  
  
end
