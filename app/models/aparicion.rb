class Aparicion < ActiveRecord::Base
  attr_accessible :canal_id, :cuna_id, :momento
  
  belongs_to :cuna
  belongs_to :canal
  
  # has_and_belongs_to_many :candidates, :join_table => "candidates_apariciones"
  
  # set_primary_keys :canal_id, :cuna_id, :momento
  self.primary_keys = :canal_id, :cuna_id, :momento
  validates_presence_of :canal_id, :cuna_id, :momento
  
  # scope :with_name, lambda {|name| where(["name ILIKE ? OR aliases ILIKE ?","%#{name}%","%#{name}%"])}
  # 
  # scope :organizacion, lambda {|name| where(["name ILIKE ? OR aliases ILIKE ?","%#{name}%","%#{name}%"])}
  # 
  # scope :gob_opo, joins(:cuna).cunas.gob_opo
  
  scope :por_canal, lambda {|canal_id| where(:canal_id => canal_id)}
  scope :por_cuna, lambda {|cuna_id| where(:cuna_id => cuna_id)}
  # scope :por_fecha, lambda {|fecha| where(["momento >= ? AND momento <= ?",fecha.to_s, (fecha+1.day-1.second).to_s])}
  
  scope :por_fecha, lambda {|fecha| where(:fecha => fecha)}
  
  def descripcion
    "Canal: #{canal.siglas} | #{fecha} | Cuna: #{cuna.descripcion} "
  end
  
  def actualizar_fecha
    self.fecha = self.momento.to_date
    self.save
  end
  
  
end


 # SELECT `apariciones`.* FROM `apariciones` INNER JOIN `candidates_apariciones` ON `apariciones`.`canal_id` = `candidates_apariciones`.`aparicion_id` AND `apariciones`.`cuna_id` IS NULL AND `apariciones`.`momento` IS NULL WHERE `candidates_apariciones`.`candidate_id` = 1
# 
# 
# scope :ordered_by_properties, :joins => [:users,:properties], 
#                               :group => "users.id", 
#                               :conditions => ["users.account_id is not null && properties.updated_at >= ?", 2.months.ago], 
#                               :order =>"COUNT(properties.id) desc, accounts.business_name asc"
#                               
#                               
#                               
#                               def properties_phones(start_day = nil, finish_day = nil)
#                                 phones = 0
#                                 self.properties.each do |p|
#                                   if start_day
#                                     phones += Statistic.where("property_id = #{p.id} AND statistic_type = 'phone' AND created_at >= '#{start_day}' AND created_at <= '#{finish_day}'").count
#                                   else
#                                     phones += Statistic.where("property_id = #{p.id} AND statistic_type='phone'").count
#                                   end
#                                 end
#                                 return phones
#                               end
#                               
#                               
#                               def apariciones_candidato
#                                 self.cunas.each do |cuna|
#                                   
#                                   cuna.apariciones.
#                                   
#                                 end
#                               
#                               end