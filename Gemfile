source :rubygems

gem 'sass'
gem 'compass'
gem 'slim'
gem 'coffee-script'

gem 'sinatra', require: 'sinatra/base'
gem 'rack-flash', require: 'rack/flash'
gem 'sinatra-r18n', require: 'sinatra/r18n'

gem 'warden'
gem 'bcrypt-ruby', require: 'bcrypt'

gem 'sqlite3'
gem 'sequel'

group :development do
  gem 'sinatra-reloader', require: 'sinatra/reloader'
end

group :test do
  gem 'minitest', require: 'minitest/spec'
  gem 'rack-test', require: 'rack/test'
  gem 'guard'
  gem 'guard-minitest'
  gem 'rb-fsevent'
  gem 'growl_notify'
end

group :production do
  gem 'rack-cache', require: 'rack/cache'
end

