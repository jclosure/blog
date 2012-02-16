class HomeController < ApplicationController
  def index

    

  end
  
  def page2


  end
  
  def page3

    redirect_to :action => "page2"

  end
  
  def page4

    redirect_to :action => "page2"

  end
  
  def page5

    redirect_to :action => "page2"

  end
  
  def page6

    redirect_to :action => "page2"

  end
  
  def flickr
    
    FlickRaw.api_key="a42deb4fd1bbae25914fddc84abcb530"
    FlickRaw.shared_secret="e68e71f5c5c60a31"
    
    
    
    
    
    
    
    
    
    list   = flickr.photos.getRecent
    
    id     = list[0].id
    secret = list[0].secret
    info = flickr.photos.getInfo :photo_id => id, :secret => secret
    
    @flick_img_url = FlickRaw.url_b(info)
    
  end
  


end
