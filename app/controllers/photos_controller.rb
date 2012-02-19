class PhotosController < ApplicationController

  require 'flickraw'


  def index
    render
  end


  def latest
    token = flickr.get_request_token(:oauth_callback => url_for(:action => 'check'))
    session[:token] = token

    page = params[:page] || 1
    per_page = session[:per_page] || 1
    
    
    list = flickr.photos.getRecent :page => page, :per_page =>  per_page
    
    @photos = list.map do |item| 
      id     = item.id
      secret = item.secret
      info = flickr.photos.getInfo :photo_id => id, :secret => secret

      photo={
        :url => FlickRaw.url(info),
        :title => info.title,
        :square_url => FlickRaw.url_s(info),
        :taken => info.dates.taken,
        :views => info.views,
        :tags => info.tags.map {|t| t.raw}
     }
    end
  end

  def show
    token = flickr.get_request_token(:oauth_callback => url_for(:action => 'check'))
    session[:token] = token

    url=params[:url]
    info = flickr.photos.getInfo(:photo_id =>url.split("/").last)
    @embed_photo={}
    @embed_photo['flickr']=FlickRaw.url(info) rescue FlickRaw.url_o(info) rescue FlickRaw.url_b(info)
    @title = info.title
    @square_url = FlickRaw.url_s(info)
    @taken = info.dates.taken
    @views = info.views
    @tags = info.tags.map {|t| t.raw}
  end

  def check
    token = session.delete :token
    session[:auth_flickr] = @auth_flickr = FlickRaw::Flickr.new
    @auth_flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], params['oauth_verifier'])
  end

  def authenticated
    @auth_flickr = session[:auth_flickr]

    login = @auth_flickr.test.login

    @auth_flickr.access_token
    %{
      You are now authenticated as <em>#{login.username}</em>
      with token <strong>#{}</strong> and secret <strong>#{@auth_flickr.access_secret}</strong>.
    }
  end

  



end
