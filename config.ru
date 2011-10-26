require './init'

use Rack::Session::Cookie
use Rack::MethodOverride
use Rack::Flash, accessorize: [:notice, :error, :success]

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = MyApp
end

Warden::Manager.serialize_into_session{|user| user.id }
Warden::Manager.serialize_from_session{|id| User[id] }

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params['user']['name'] && params['user']['password']
  end
  
  def authenticate!
    user = User.authenticate(
      params['user']['name'], 
      params['user']['password']
      )
    user.nil? ? fail!('Could not log in') : success!(user, 'Successfully logged in')
  end
end

map '/' do
  run MyApp
end