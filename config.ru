require './init'

use Rack::Cache if ENV['RACK_ENV'] == 'production'

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = MyApp
end

map '/' do
  run MyApp
end