module Twitter
  extend Configuration

  def self.client(options={})
    Twitter::Client.new(options)
  end

end