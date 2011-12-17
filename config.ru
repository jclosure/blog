# This file is used by Rack-based servers to start the application.

##DEFAULT - DOESN'T WORK WITH HEROKU
require ::File.expand_path('../config/environment',  __FILE__)
run Blog::Application

##
# works with heroku

#require "config/environment"

#use Rails::Rack::LogTailer
#use Rails::Rack::Static
#run ActionController::Dispatcher.new
