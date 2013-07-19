class Website < ActiveRecord::Base
  attr_accessible :descripcion, :logo, :nombre, :url

  has_many :notas
  accepts_nested_attributes_for :notas

  def eliminar_notas_irrelevantes
    self.notas.each { |nota| nota.destroy unless nota.resumen_id }
  end

end
