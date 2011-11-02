module App
  class Public < App::Base
    
    configure do
      Compass.configuration do |c|
        c.environment = environment
        c.project_path = root
        c.sass_dir = File.join('views','stylesheets')
        c.output_style = development? ? :expanded : :compressed
        c.relative_assets = development?
      end
      set :sass, Compass.sass_engine_options
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