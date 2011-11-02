module App
  class Base < Sinatra::Base
    
    configure do
      set :app_file, '.'
      register Sinatra::R18n
    end
    
    configure :development do
      register Sinatra::Reloader
    end
    
    before do
      session[:locale] = params[:locale] if params[:locale]
    end
    
  end
end