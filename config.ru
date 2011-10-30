require './init'

use Rack::Cache

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = MyApp
end

map '/' do
  run MyApp
end