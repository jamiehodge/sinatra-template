module App
  module Controller
    class Base < Sinatra::Base

      configure do
        set :app_file, File.expand_path('../', __FILE__)
        register Sinatra::R18n
      end

      configure :development do
        register Sinatra::Reloader
      end

      helpers App::Helper::Base

      before do
        session[:locale] = params[:locale] if params[:locale]
      end

      not_found do
        slim :not_found
      end
    end
  end
end