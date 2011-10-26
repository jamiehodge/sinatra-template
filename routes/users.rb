class MyApp < Sinatra::Base
  
  get '/users' do
    slim :'users/index', locals: { users: User.all }
  end
  
  get '/users/new' do
    slim :'users/new'
  end
  
  post '/users/new' do
    user = User.new(params[:user])
    if user.valid?
      user.save
      redirect to '/users'
    else
      redirect to '/users/new'
    end
  end
  
  get '/users/:id' do
    not_found unless user = User[params[:id]]
    slim :'users/show', locals: { user: user }
  end
  
  get '/users/:id/edit' do
    not_found unless user = User[params[:id]]
    slim :'users/edit', locals: { user: user }
  end
  
  put '/users/:id' do
    not_found unless user = User[params[:id]]
    user.update(params[:user])
    redirect to "/users/#{user.id}"
  end
end