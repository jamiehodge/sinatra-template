class MyApp < Sinatra::Base
  get '/' do
    @page_title = 'Welcome'
    slim :index
  end
  
  get '/protected' do
    protected!
    slim 'h1 Protected'
  end
  
  not_found do
    'Not found'
  end
  
  error do
    'Error'
  end
end