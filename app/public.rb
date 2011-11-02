module App
  class Public < Sinatra::Base
    
    configure do
      set :app_file, '.'
      Compass.configuration do |c|
        c.environment = environment
        c.project_path = root
        c.sass_dir = File.join('views','stylesheets')
        c.output_style = development? ? :expanded : :compressed
        c.relative_assets = development?
      end
      set :sass, Compass.sass_engine_options
      
      register Sinatra::R18n
    end
    
    before do
      session[:locale] = params[:locale] if params[:locale]
    end
    
    get '/stylesheets/:name.css' do
      sass :"stylesheets/#{params[:name]}"
    end
    
    get '/js/:name.js' do
      coffee :"js/#{params[:name]}"
    end
    
    get '/' do
      slim :index
    end
  end
end