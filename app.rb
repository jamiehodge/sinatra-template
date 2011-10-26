class MyApp < Sinatra::Base
  
  configure do
    set :app_file, __FILE__
    
    Compass.configuration do |c|
      c.environment = environment
      c.project_path = root
      c.sass_dir = File.join('views','stylesheets')
      c.output_style = development? ? :expanded : :compressed
      c.relative_assets = development?
    end
    set :sass, Compass.sass_engine_options
    
    enable :sessions, :logging, :method_override
    use Rack::Flash, accessorize: [:notice, :error, :success]
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
  
  get '/stylesheets/:name.css' do
    sass :"stylesheets/#{params[:name]}"
  end
end