class Nota < ActiveRecord::Base
  belongs_to :tipo_nota
  belongs_to :website
  # belongs_to :resumen
  
  attr_accessible :contenido, :titulo, :url, :website_id, :tipo_nota_id, :resumen_id, :imagen
  validates_presence_of :titulo, :url, :website_id, :tipo_nota_id
  validates_uniqueness_of :url
    # validates_associated :tolda, :tipo, :cunas
    
  scope :creadas_hoy, -> {where("created_at >= ?", Date.today)}
  
  scope :creadas_antes, -> {where("created_at < ?", Date.today)}
  
  scope :creadas_hoy_no_incluidas_en_resumen, -> resumen_id {creadas_hoy.where("resumen_id != ? OR resumen_id IS ?", resumen_id, nil)}
  
  scope :validas, ->{where(:tipo_nota_id => 2)}
  
  scope :invalidas, ->{where(:tipo_nota_id => 1)}
  
  def valida?
    if tipo_nota_id == 1
      return false
    else
      return true
    end 
  end
  
  def self.creadas_hoy_no_incluidas (resumen_id)
    creadas_hoy.where("resumen_id != ? OR resumen_id IS ?", resumen_id, nil)    
  end
  
  def descripcion
    "#{website.descripcion} / #{titulo[0..20]}..."
  end
  
end
