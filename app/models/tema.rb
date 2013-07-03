class Tema < ActiveRecord::Base
  validates_presence_of :asunto_id
  attr_accessible :descripcion, :nombre, :asunto_id
  belongs_to :asunto
end
