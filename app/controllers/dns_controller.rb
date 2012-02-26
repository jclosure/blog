require 'combinator'
require 'dns_trawler'

class DnsController < ApplicationController

  def index

  end
  

  def available
    names = params[:dnsnames]
    combinator = Combinator.new
    
    unless(params[:prefix].nil?) 
      names = combinator.add_prefix(params[:prefix], names.split).join " "
    end
    unless(params[:suffix].nil?) 
        names = combinator.add_suffix(params[:suffix], names.split).join " "
    end
    
    @io = DnsTrawler.new.find_available names, params[:tld]
  end

end
