
Twitter.configure do |config|
  config.consumer_key = Rails.application.config.twitter_consumer_key
  config.consumer_secret = Rails.application.config.twitter_consumer_secret
  config.oauth_token = Rails.application.config.twitter_oauth_token
  config.oauth_token_secret = Rails.application.config.twitter_oauth_token_secret
  #config.proxy = ENV['APIGEE_TWITTER_API_ENDPOINT']
end


