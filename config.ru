require './init'

use Rack::Parser
use Rack::MethodOverride
use Rack::Session::Cookie
use Rack::Flash, accessorize: [:notice, :error, :success]
use Rack::Cache if ENV['RACK_ENV'] == 'production'

use Warden::Manager do |config|
  config.scope_defaults :default,
    strategies: [:password], 
    action: 'session/unauthenticated'
  config.scope_defaults :api,
    strategies: [:basic],
    action: 'session/unauthenticated'
  config.failure_app = self
end

map '/' do
  run App::Public
end

map '/session' do
  run App::Session
end

map '/admin' do
  map '/users' do
    run App::Users
  end
end

