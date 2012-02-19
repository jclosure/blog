class TumbleController < ApplicationController
  def index
    session[:per_page] = 3 if session[:per_page].nil?
    # session[:per_page] += 1
  end
  
  def page
    redirect_to :controller => 'photos', :action => 'latest'
  end
  
end
