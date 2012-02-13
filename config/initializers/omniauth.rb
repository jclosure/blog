Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'wz4Ax8ULQNfQ0YFtzOJig', '2YAjI4jvZY4ILc6fdHtj0r02oDTa8TutGNYodEreZbI' # todo: move this into env config
  provider :twitter, Rails.application.config.twitter_consumer_key, Rails.application.config.twitter_consumer_secret
end