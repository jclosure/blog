require 'tweet'

class ApplicationController < ActionController::Base
  include Tweet
  protect_from_forgery
end
