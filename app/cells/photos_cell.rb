class PhotosCell < Cell::Rails

   require 'flickraw'

  def display(opts)
    
     token = flickr.get_request_token(:oauth_callback => url_for(:action => 'check'))
     session[:token] = token

     page = params[:page] || 1
     per_page = session[:per_page] || 1

     

     list = flickr.photos.getRecent :page => 1, :per_page =>  5

     @photos = list.map do |item| 
       id     = item.id
       secret = item.secret
       info = flickr.photos.getInfo :photo_id => id, :secret => secret

       photo={
         :id => id,
         :secret => secret,
         :url => FlickRaw.url(info),
         :title => info.title,
         :square_url => FlickRaw.url_s(info),
         :taken => info.dates.taken,
         :views => info.views,
         :tags => info.tags.map {|t| t.raw}
      }
     end
     
     render
     
  end


  def page
    redirect_to :action => 'display'
  end



end
