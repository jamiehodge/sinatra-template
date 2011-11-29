module Sinatra
  module Resource
    
    def resource(model)
      
      member = model.name.split(':').last.downcase
      collection = "#{member}s"

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
        not_found unless @record = model[params[:id]]
      end
      
      # index
      get '/?', provides: :html do
        slim :"#{collection}/index", locals: { :"#{collection}" => model.all }
      end
      
      get '/?', provides: :json do
        MultiJson.encode(model.all.map {|record| record.values })
      end

      # new
      get '/new/?', provides: :html do
        slim :"#{collection}/new"
      end

      # create
      post '/?' do
        @record = model.create(params[:user])
        pass
      end

      post '/?', provides: :html do
        redirect to "/#{@record.id}"
      end

      post '/?', provides: :json do
        headers \
          'Location' => url("/#{@record.id}"),
          'Content-Location' => url("/#{@record.id}")
        status 201
        MutiJson.encode(@record.values)
      end

      # read
      get '/:id/?', provides: :html do
        slim :"#{collection}/show", locals: { :"#{member}" => @record }
      end

      get '/:id/?', provides: :json do
        MultiJson.encode(@record.values)
      end

      # edit
      get '/:id/edit', provides: :html do
        slim :"#{collection}/edit", locals: { :"#{member}" => @record }
      end

      # update
      put '/:id/?' do
        @record.update(params[:"#{member}"])
        pass
      end

      put '/:id/?', provides: :html do
        redirect to "/#{@record.id}"
      end

      put '/:id/?', provides: :json do
        204
      end

      # destroy
      delete '/:id/?' do
        halt 403 unless @record.destroy
        pass
      end

      delete '/:id/?', provides: :html do
        redirect to '/'
      end

      delete '/:id/?', provides: :json do
        204
      end

      # errors
      error Sequel::ValidationFailed, Sequel::HookFailed do
        422
      end
    end
    
    module Helpers
    end
    
    def self.registered(app)
      app.helpers Resource::Helpers
    end
  end
  
  register Resource
end