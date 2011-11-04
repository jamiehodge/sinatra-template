Warden::Manager.serialize_into_session{|user| user.id }
Warden::Manager.serialize_from_session{|id| User[id] }

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params['user'] && params['user']['name'] && params['user']['password']
  end
  
  def authenticate!
    user = User.authenticate(
      params['user']['name'], 
      params['user']['password']
      )
    user.nil? ? fail!('Could not log in') : success!(user, 'Successfully logged in')
  end
end

Warden::Strategies.add(:basic) do
  
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end
  
  def valid?
    auth.provided? && auth.basic? && auth.credentials
  end
  
  def authenticate!
    user = User.authenticate(
      auth.credentials.first,
      auth.credentials.last
    )
    user.nil? ? fail! : success!(user)
  end
  
  def store?
    false
  end
end