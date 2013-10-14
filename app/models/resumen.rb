class Resumen < ActiveRecord::Base
  belongs_to :vocero
  belongs_to :informe
  belongs_to :tema
  
  has_many :notas
  accepts_nested_attributes_for :notas
  
  attr_accessible :contenido, :titulo, :vocero_id, :tema_id, :informe_id
  
  scope :creados_hoy, -> {where("created_at >= ?", Date.today)}
  
  def descripcion
    contenido_parcial = contenido.blank? ? "" : "#{contenido[0..40]}..."
    "#{id}.- #{contenido_parcial}. Notas: #{notas.count} creado: #{created_at}."
  end
end
