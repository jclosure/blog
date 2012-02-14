require 'tweet'

class ApplicationController < ActionController::Base
  include Tweet
  protect_from_forgery
  
  helper_method :current_user
  
  # uncomment to only allow html requests to be served
  #before_filter :allow_only_html_requests

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def allow_only_html_requests
      if params[:format] && params[:format] != "html"
        render :file => "#{RAILS_ROOT}/public/404.html"
      end
    end
  
end
