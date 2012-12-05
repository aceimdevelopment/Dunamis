class Candidate < ActiveRecord::Base
  attr_accessible :description, :foto, :name, :organizacion_id, :estado_id
  
  belongs_to :organizacion
  belongs_to :estado
  
  # has_many :cunas
  has_and_belongs_to_many :cunas, :join_table => "candidates_cunas"
  # has_and_belongs_to_many :apariciones, :join_table => "candidates_apariciones"
  # accepts_nested_attributes_for :cunas
  
  validates_presence_of :name, :organizacion_id, :estado_id
  validates :name, :uniqueness => true
  
  scope :by_cunas, joins(:cunas).where('apariciones.momento = ?', Time.now)
  
  scope :oposicion, joins(:organizacion).where('organizaciones.tolda_id = 1')
  scope :chavismo, joins(:organizacion).where('organizaciones.tolda_id = 2')
  scope :independiente, joins(:organizacion).where('organizaciones.tolda_id = 3')
  
  def full_descripcion
    "#{id} - #{name} - #{description}"
  end
  
  def apariciones_candidatos apariciones
    canales_conteo = Hash.new
    canales = Canal.order :siglas
    canales.each {|c| canales_conteo["#{c.siglas}"]=0}
    apariciones.each do |aparicion|
      canales_conteo["#{aparicion.canal.siglas}"] += aparicion.cuna.duracion if aparicion.cuna.candidates.include? self
    end
    return canales_conteo
  end

  def apariciones_candidatos_cantidad apariciones
    canales_conteo = Hash.new
    canales = Canal.order :siglas
    canales_conteo["total"] = 0
    canales_conteo["solo"] = 0
    canales_conteo["combo"] = 0
    canales_conteo["nacional"] = 0
    canales.each {|c| canales_conteo["#{c.siglas}"]=0}
    apariciones.each do |aparicion|
      if aparicion.cuna.candidates.include? self
        count = aparicion.cuna.candidates.count
        canales_conteo["#{aparicion.canal.siglas}"] += aparicion.cuna.duracion 
        canales_conteo["total"] += 1
        # case count
        #   when 1
        #       canales_conteo["solo"] += 1
        #   when count > 9
        #       canales_conteo["nacional"] += 1
        #   else
        #       canales_conteo["combo"] += 1
        # end #fin case

        if count == 1
          canales_conteo["solo"] += 1
        elsif count > 9
          canales_conteo["nacional"] += 1
        else
          canales_conteo["combo"] += 1
        end #fin if_anidado
      end #fin if
    end # fin do
    return canales_conteo
  end
  
  def solo
    count = 0
    self.cunas.each{|cuna| count += 1 if cuna.candidates.count == 1}
    return count
  end
  
  def nacional
    count = 0
    self.cunas.each{|cuna| count += 1 if cuna.candidates.count >= 6}
    return count    
  end
  
end
