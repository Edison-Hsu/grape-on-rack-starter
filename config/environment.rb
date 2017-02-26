# Set rack environment
ENV['RACK_ENV'] ||= "development"
puts "Current environment is #{ENV['RACK_ENV']}"

ENV["RACK_ROOT"] = File.expand_path('../', File.dirname(__FILE__))
puts "Current application root is #{ENV["RACK_ROOT"]}"

# Load the application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
# Rails.application.initialize!
