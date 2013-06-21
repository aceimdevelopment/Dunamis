class Candidato < ActiveRecord::Base
  require 'composite_primary_keys'
  set_primary_keys :vocero_id,:eleccion_id


  belongs_to :vocero
  belongs_to :eleccion
  belongs_to :municipio
  belongs_to :tipo_cargo

end
