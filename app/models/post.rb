class Post < ActiveRecord::Base
  belongs_to :website
  attr_accessible :nombre, :website_id
  validates_presence_of :nombre, :website_id
end
