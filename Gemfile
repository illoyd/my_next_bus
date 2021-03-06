source 'https://rubygems.org'

ruby '2.1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 4.0.0.beta2'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0.0.beta4'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

#
# Adding twitter bootstrap tools
gem 'bootstrap-sass', '~> 3.2.0'
gem 'bootstrap-sass-extras'
gem 'autoprefixer-rails'

#
# Additional gems
gem 'responders'
gem 'haml'
gem 'haml-rails'
gem 'hashie'
gem 'ai4r'
gem 'httpclient'

#
# Reporting gems
gem 'hightop'
gem 'groupdate'
gem 'active_median'
gem 'chartkick'

#
# Service gems
# gem 'twitter', '~> 5.11.0'

#
# Model extensions
gem 'active_model_serializers', '~> 0.8.0'
gem 'attribute_normalizer', git: 'https://github.com/illoyd/attribute_normalizer.git'
gem 'workflow'
gem 'rest-client'
gem 'httparty'

#
# Authorisations
gem 'devise', '~> 3.4'
gem 'devise-async'
gem 'cancancan', '~> 1.9'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'

#
# Internal services (e.g. queues, caches)
gem 'rack-cache'
gem 'dalli'
gem 'kgio'
gem 'redis'
gem 'redis-rails'
gem 'sidekiq', '~> 3.2'
gem 'sinatra', '>= 1.3.0', :require => nil

#
# Test and development gems
group :test, :development do
  gem "rspec-rails"
end

#
# Test gems
group :test do
	gem 'shoulda-matchers'
	gem 'rspec-sidekiq'
	gem 'rspec-its'
	gem 'vcr'
	gem 'webmock', "~> 1.11.0"
	gem 'factory_girl_rails'
	gem 'fuubar'
  gem 'simplecov', :require => false
  gem 'faker'
end

#
# Production gems
group :production do
  gem 'newrelic_rpm'
  gem 'lograge'
end

gem 'rails_12factor', group: [:development, :production]
