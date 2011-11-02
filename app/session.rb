module App
  class Session < App::Base
    
    get '/new' do
      slim :'/session/new'
    end

    post '/' do
      env['warden'].authenticate!
      flash.success = env['warden'].message
      redirect session[:return_to]
    end

    delete '/' do
      env['warden'].raw_session.inspect
      env['warden'].logout
      flash.success = 'Successfully logged out'
      redirect '/'
    end

    post '/unauthenticated' do
      session[:return_to] = env['warden.options'][:attempted_path]
      flash.notice = env['warden'].message
      redirect to '/new'
    end
    
    not_found do
      redirect '/'
    end
  end
end