module Sinatra
  module Resource
    
    module Helpers  
      def record_name
        settings.resource.name.split(':').last.downcase
      end
      
      def resource_name
        record_name + 's'
      end
    end
    
    def self.registered(app)
      app.helpers Resource::Helpers
      
      app.set :resource, 'resource class'
      
      # app.use Rack::Parser

      app.before provides: :html do
        if settings.mime_types(:html).include? request.preferred_type
          env['warden'].authenticate!
        end
      end

      app.before provides: :json do
        if settings.mime_types(:json).include? request.preferred_type
          env['warden'].authenticate! scope: :api
        end
      end

      app.before %r{^/(?<id>\d+)} do
        not_found unless @record = settings.resource[params[:id]]
      end

      # index
      app.get '/?', provides: :html do
        slim :"#{resource_name}/index", locals: { :"#{resource_name}" => settings.resource.all }
      end

      app.get '/?', provides: :json do
        MultiJson.encode(settings.resource.all.map {|record| record.values })
      end

      # new
      app.get '/new/?', provides: :html do
        slim :"#{resource_name}/new"
      end

      # create
      app.post '/?' do
        @record = settings.resource.create(params[:user])
        pass
      end

      app.post '/?', provides: :html do
        redirect to "/#{@record.id}"
      end

      app.post '/?', provides: :json do
        headers \
          'Location' => url("/#{@record.id}"),
          'Content-Location' => url("/#{@record.id}")
        status 201
        MutiJson.encode(@record.values)
      end

      # read
      app.get '/:id/?', provides: :html do
        slim :"#{resource_name}/show", locals: { :"#{record_name}" => @record }
      end

      app.get '/:id/?', provides: :json do
        MultiJson.encode(@record.values)
      end

      # edit
      app.get '/:id/edit', provides: :html do
        slim :"#{resource_name}/edit", locals: { :"#{record_name}" => @record }
      end

      # update
      app.put '/:id/?' do
        @record.update(params[:"#{record_name}"])
        pass
      end

      app.put '/:id/?', provides: :html do
        redirect to "/#{@record.id}"
      end

      app.put '/:id/?', provides: :json do
        204
      end

      # destroy
      app.delete '/:id/?' do
        halt 403 unless @record.destroy
        pass
      end

      app.delete '/:id/?', provides: :html do
        redirect to '/'
      end

      app.delete '/:id/?', provides: :json do
        204
      end

      # errors
      app.error Sequel::ValidationFailed, Sequel::HookFailed do
        422
      end
    end
  end
  
  register Resource
end