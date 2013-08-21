class TipoWebnota < ActiveRecord::Base
  belongs_to :website
  attr_accessible :div_contenido, :div_fecha, :div_imagen, :div_nota, :div_titulo, :website_id
  validates_presence_of :div_contenido, :div_fecha, :div_imagen, :div_nota, :div_titulo, :website_id
end
