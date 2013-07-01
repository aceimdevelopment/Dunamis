class Tema < ActiveRecord::Base
  attr_accessible :descripcion, :nombre, :asunto_id
  belongs_to :asunto
end
