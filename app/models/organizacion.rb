class Organizacion < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :nombre_corto, :rif, :tolda_id, :tipo_id, :estado_id, :municipio_id
  belongs_to :tolda
  belongs_to :tipo
  belongs_to :estado
  
  has_many :candidates
  accepts_nested_attributes_for :candidates
  
  has_many :cunas
  accepts_nested_attributes_for :cunas
  
  validates_presence_of :nombre, :nombre_corto, :tolda_id, :tipo_id
  validates_associated :tolda, :tipo, :cunas
  
  # Gobernaciones
  scope :gob_opo, where('tolda_id = ? AND tipo_id = ?', 1, 2)
  scope :gob_ch, where('tolda_id = ? AND tipo_id = ?', 2, 2)
  
  # Partidos
  scope :mud, where('tolda_id = ? AND tipo_id = ?', 1, 1)
  scope :psuv, where('tolda_id = ? AND tipo_id = ?', 2, 1)
  
  scope :nombre_completo, lambda {|nombre| where(["nombre LIKE ? OR nombre_corto LIKE ? OR descripcion LIKE ?","%#{nombre}%","%#{nombre}%","%#{nombre}%"])}
  
  def alianza
    "#{self.tipo.nombre[0..2].capitalize}-#{self.tolda.nombre[0..2].capitalize}"
  end
end
