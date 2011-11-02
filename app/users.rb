module App
  class Users < App::Base
    
    helpers do
      def cycle
        @cycle ||= %w{odd even}.cycle
      end
    end
    
    before do
      env['warden'].authenticate!
    end
    
    before %r{^/(?<id>\d+)} do
      not_found unless @user = User[params[:id]]
    end
    
    # index
    get '/' do
      slim :'users/index', locals: { users: User.all }
    end

    # new
    get '/new' do
      slim :'users/new'
    end

    # create
    post '/' do
      error 400 unless user = User.create(params[:user])
      redirect to "/#{user.id}"
    end

    # read
    get '/:id' do
      slim :'users/show', locals: { user: @user }
    end

    # edit
    get '/:id/edit' do
      slim :'users/edit', locals: { user: @user }
    end

    # update
    put '/:id' do
      @user.update(params[:user])
      redirect to "/#{@user.id}"
    end

    # destroy
    delete '/:id' do
      @user.destroy
      redirect to '/'
    end
  end
end