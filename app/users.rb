module App
  class Users < App::Base
    
    use Rack::Parser
    
    helpers do
      def cycle
        @cycle ||= %w{odd even}.cycle
      end
    end
    
    before provides: :html do
      if settings.mime_types(:html).include? request.preferred_type
        env['warden'].authenticate!
      end
    end
    
    before provides: :json do
      if settings.mime_types(:json).include? request.preferred_type
        env['warden'].authenticate! scope: :api
      end
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
      @user = User.create(params[:user])
      pass
    end
    
    post '/', provides: :html do
      redirect to "/#{@user.id}"
    end
    
    post '/', provides: :json do
      headers \
        'Location' => url("/#{@user.id}"),
        'Content-Location' => url("/#{@user.id}")
      status 201
      MutiJson.encode(@user.values)
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
      halt 403 unless @user.destroy
      pass
    end
    
    delete '/:id', provides: :html do
      redirect to '/'
    end
    
    delete '/:id', provides: :json do
      204
    end
    
    # errors
    error Sequel::ValidationFailed, Sequel::HookFailed do
      422
    end
    
  end
end