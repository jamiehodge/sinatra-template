module App
  class Users < App::Base
    
    helpers do
      def cycle
        @cycle ||= %w{odd even}.cycle
      end
    end
    
    before provides: :html do
      env['warden'].authenticate!
    end
    
    before provides: :json do
      env['warden'].authenticate! scope: :api
    end
    
    before %r{^/(?<id>\d+)} do
      not_found unless @user = User[params[:id]]
    end
    
    # index
    get '/', provides: :html do
      slim :'users/index', locals: { users: User.all }
    end
    
    get '/', provides: :json do
      MultiJson.encode(User.all.map {|user| user.values })
    end

    # new
    get '/new' do
      slim :'users/new'
    end

    # create
    post '/' do
      error 400 unless @user = User.create(params[:user])
      pass
    end
    
    post '/', provides: :html do
      redirect to "/#{@user.id}"
    end
    
    post '/', provides: :json do
      headers 'Location' => url("/#{@user.id}")
      201
    end

    # read
    get '/:id', provides: :html do
      slim :'users/show', locals: { user: @user }
    end
    
    get '/:id', provides: :json do
      MultiJson.encode(@user.values)
    end

    # edit
    get '/:id/edit' do
      slim :'users/edit', locals: { user: @user }
    end

    # update
    put '/:id' do
      @user.update(params[:user])
      pass
    end
    
    put '/:id', provides: :html do
      redirect to "/#{@user.id}"
    end
    
    put '/:id', provides: :json do
      204
    end

    # destroy
    delete '/:id' do
      @user.destroy
      pass
    end
    
    delete '/:id', provides: :html do
      redirect to '/'
    end
    
    delete '/:id', provides: :json do
      204
    end
  end
end