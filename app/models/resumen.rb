class Resumen < ActiveRecord::Base
  belongs_to :vocero
  belongs_to :informe
  belongs_to :tema
  
  belongs_to :resumen
  has_many :resumenes
  accepts_nested_attributes_for :resumenes
  
  has_many :notas
  accepts_nested_attributes_for :notas
  
  attr_accessible :contenido, :titulo, :vocero_id, :tema_id, :informe_id, :otro_vocero
  
  scope :creados_hoy, -> {where("created_at >= ?", Date.today)}
  
  scope :sin_tema, -> {where("tema_id IS ?", nil)}
  
  scope :sin_informe, -> {where("informe_id IS ?", nil)}
  
  scope :con_tema, -> {where("tema_id IS NOT ?", nil)}
  
  scope :creados_hoy_sin_tema_agregados, -> informe_id {where("created_at >= ? and informe_id IS ? and tema_id IS ?", Date.today, informe_id, nil)}
  
  def eql_vocero?
    if resumen 
      return vocero.nombre.eql? resumen.vocero.nombre
    else
      return false
    end
  end

  def descripcion
    aux = ""
    aux += "#{tema.nombre} - " if tema
    aux += contenido if contenido

  end
  
  def descripcion_corta
    (descripcion.eql? "-") ? "Sin descripcion" : "#{descripcion[0..100]}..."
  end
end
