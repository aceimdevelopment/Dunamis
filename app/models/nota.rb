class Nota < ActiveRecord::Base
  belongs_to :tipo_nota
  belongs_to :website
  # belongs_to :resumen
  
  attr_accessible :contenido, :titulo, :url, :website_id, :tipo_nota_id, :resumen_id
  validates_presence_of :titulo, :url, :website_id, :tipo_nota_id
  validates_uniqueness_of :url
    # validates_associated :tolda, :tipo, :cunas
end
