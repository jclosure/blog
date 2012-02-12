
if Rails.env.production?
  Twitter.configure do |config|
    config.consumer_key = "wz4Ax8ULQNfQ0YFtzOJig"
    config.consumer_secret = "2YAjI4jvZY4ILc6fdHtj0r02oDTa8TutGNYodEreZbI"
    config.oauth_token = "293860890-sshxBMYWdn4Amgj5EiyQVJ31Iv3Hr3dAOgTEHxLY"
    config.oauth_token_secret = "gFEHMmeXjJBQBLgwOVYVStFpqEF03cp0FxeqGimeTJM"
    #config.proxy = ENV['APIGEE_TWITTER_API_ENDPOINT']
  end
end

