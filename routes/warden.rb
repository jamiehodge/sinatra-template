class MyApp < Sinatra::Base

  get '/login' do
    slim :'users/login'
  end
  
  post '/login' do
    warden.authenticate!
    flash.success = warden.message
    redirect to '/'
  end
  
  get '/logout' do
    warden.logout
    flash.notice = 'Sucessfully logged out'
    redirect to '/'
  end
  
  post '/unauthenticated' do
    flash.error = warden.message
    redirect to '/login'
  end
end