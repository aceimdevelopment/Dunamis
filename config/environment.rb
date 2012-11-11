# Load the rails application
require File.expand_path('../application', __FILE__)
require "#{Rails.root}/app/overrides/all"
# Initialize the rails application
Dunamis::Application.initialize!
