if Rails.env.production?
  Twitter.configure do |config|
    config.consumer_key = "bHsNavLBTYzaDMIZ3yHrA"
    config.consumer_secret = "lA2B0SApJ3VcHxTeQ7bMcfJAefX710DYezinvKuVd0"
    config.oauth_token = "293860890-5714YdHWOy7fU45i1gPZRIbkGtJVoGNhIWrDwQL6"
    config.oauth_token_secret = "zPbmZtsrmzvsF3psxwTYgXDJxYntqZL3rmlX3KQOYro"
    #config.proxy = ENV['APIGEE_TWITTER_API_ENDPOINT']
  end
end