class Resumen < ActiveRecord::Base
  belongs_to :vocero
  belongs_to :informe
  belongs_to :tema
  
  belongs_to :resumen
  has_many :resumenes
  accepts_nested_attributes_for :resumenes
  
  has_many :notas
  accepts_nested_attributes_for :notas
  
  attr_accessible :contenido, :titulo, :vocero_id, :tema_id, :informe_id
  
  scope :creados_hoy, -> {where("created_at >= ?", Date.today)}
  
  def eql_vocero?
    if resumen 
      return vocero.nombre.eql? resumen.vocero.nombre
    else
      return false
    end
  end
  
  def descripcion
    contenido_parcial = contenido.blank? ? "" : "#{contenido[0..40]}..."
    "#{id}.- #{contenido_parcial}. Notas: #{notas.count} creado: #{created_at}."
  end
end
