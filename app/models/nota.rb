class Nota < ActiveRecord::Base
  belongs_to :tipo_nota
  belongs_to :website
  belongs_to :resume
  attr_accessible :contenido, :titulo, :url
end
