class MyApp < Sinatra::Base
  
  configure do
    set :app_file, __FILE__
  end
  
  configure :development do
    Compass.add_project_configuration('config/compass.rb')
    
    get '/stylesheets/:name.css' do
      content_type 'text/css', charset: 'utf-8'
      sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options)
    end
  end
  
  configure :production do
    
  end
  
  helpers do
    include Sinatra::WardenHelpers
    include Rack::Utils
    alias_method :h, :escape_html
  end
  
  before do
    @app_title = 'Sinatra Template'
    @page_title = request.path_info.gsub(/\//,' ').strip.capitalize
  end
end