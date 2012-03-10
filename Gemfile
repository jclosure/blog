source 'http://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# http://blog.carbonfive.com/2012/02/27/supporting-cross-domain-ajax-in-rails-using-jsonp-and-cors/
gem 'rack-jsonp-middleware', :require => 'rack/jsonp'
gem 'rack-cors', :require => 'rack/cors'

#gem 'mysql2'
gem 'sqlite3'

gem 'cells'

gem 'whois'
gem 'seeker', :git => 'git://github.com/jclosure/seeker.git'
gem 'mechanize' #see docs: https://rubygems.org/gems/mechanize

#gem 'refinerycms', '= 1.0.9'

gem 'twitter'
gem 'flickraw'

gem 'omniauth'
gem 'omniauth-twitter'

group :development, :test do
  gem "rspec-rails", "~> 2.0"
end

group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3'
  #gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'pg'
end


# 
gem 'rails-boilerplate'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end

gem 'faraday'
gem 'faraday_middleware'
gem 'hashie'
#gem 'simple_oauth'
