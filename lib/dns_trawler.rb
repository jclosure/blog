
class DnsTrawler

  def initialize
    @list = []
  end

  def build_prefixed
    
  end
  
  def build_suffixed
    
  end

	def find_available dns_names, tld
	  @io = StringIO.new
		begin
		  @list = dns_names.split
      @list.each { |n| n.strip! }
      seeker = Seeker.new
      seeker.set_out { @io }
      seeker.work_list(@list) do |word|
        unless tld == ''
          word + '.' + tld
        else
          word
        end
      end
    rescue
      #log
    end
    @io
	end

end