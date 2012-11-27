class Canal < ActiveRecord::Base
  attr_accessible :nombre, :siglas
  
  has_many :apariciones
  accepts_nested_attributes_for :apariciones
  
  # default_scope order('nombre')
    
end
