class HomeController < ApplicationController
  def index
    #reset_session
  end
  
  def page
    redirect_to :action => 'latest'
  end
  
  def bubblezoo
    #render_component '/photos/page'
  end
  
  
end
