class MyApp < Sinatra::Base
  
  get '/users' do
    slim :'users/index', locals: { users: User.all }
  end
  
  get '/users/new' do
    slim :'users/new'
  end
  
  post '/users' do
    user = User.new(params[:user])
    if user.valid?
      user.save
      redirect to '/users'
    else
      redirect to '/users/new'
    end
  end
  
  before %r{/users/([\d]+)} do |id|
    not_found unless @user = User[id]
  end
  
  get '/users/:id' do
    slim :'users/show', locals: { user: @user }
  end
  
  get '/users/:id/edit' do
    slim :'users/edit', locals: { user: @user }
  end
  
  put '/users/:id' do
    @user.update(params[:user])
    redirect to "/users/#{@user.id}"
  end
  
  delete '/users/:id' do
    @user.destroy
    redirect to '/users'
  end
end