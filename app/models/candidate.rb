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
  
  def full_descripcion
    "#{id} - #{name} - #{description}"
  end
  
end
