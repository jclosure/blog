Blog::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
 #CHANGED BY JOEL TO ALLOW IMAGES TO WORK
 config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
config.action_dispatch.x_sendfile_header = nil # For Heroku
  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  # Fix to load local modules from lib directory in Heroku
  config.autoload_paths += Dir["#{config.root}/lib/**/"]
  
  # CUSTOM CONFIGURATION VARIABLES
  # noolog
  config.twitter_consumer_key = 'wz4Ax8ULQNfQ0YFtzOJig'
  config.twitter_consumer_secret = '2YAjI4jvZY4ILc6fdHtj0r02oDTa8TutGNYodEreZbI'
  # jclosure
  config.twitter_oauth_token = "293860890-r0AIqy8LL6X0TQVahWEEoXb1v5Bk6HwyrnENPiwW".encode('utf-8')
  config.twitter_oauth_token_secret = "2dvsPAAsVNs3M8lYo8IJcNPcDsPd7ZzgnQTL9qszlw".encode('utf-8')
end
