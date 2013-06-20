class Website < ActiveRecord::Base
  attr_accessible :descripcion, :logo, :nombre, :url
end
