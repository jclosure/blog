class MarkletController < ApplicationController
  def index
  end
  def capture
    @text = params[:text] || "Text not sent."
    render :layout => 'marklet_uber' 
  end
end
