class DnsController < ApplicationController

  def index

  end

  def available
    begin
      dns_names = params[:dnsnames]
      tld = params[:tld]
      @list = dns_names.split.each { |n| n.strip! }
      @io = StringIO.new
      seeker = Seeker.new
      seeker.set_out { @io }
      seeker.work_list(@list) { |word| word + '.' + tld }
    rescue
      #log
    end
  end

end
