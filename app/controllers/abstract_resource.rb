module App
  module Controller
    class AbstractResource < Base

      # use Rack::Parser

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
        not_found unless @record = @resource[params[:id]]
      end

      # index
      get '/', provides: :html do
        slim :"#{resource_name}/index", locals: { :"#{resource_name}" => @resource.all }
      end

      get '/', provides: :json do
        MultiJson.encode(@resource.all.map {|record| record.values })
      end

      # new
      get '/new', provides: :html do
        slim :"#{resource_name}/new"
      end

      # create
      post '/' do
        @record = @resource.create(params[:user])
        pass
      end

      post '/', provides: :html do
        redirect to "/#{@record.id}"
      end

      post '/', provides: :json do
        headers \
          'Location' => url("/#{@record.id}"),
          'Content-Location' => url("/#{@record.id}")
        status 201
        MutiJson.encode(@record.values)
      end

      # read
      get '/:id', provides: :html do
        slim :"#{resource_name}/show", locals: { :"#{record_name}" => @record }
      end

      get '/:id', provides: :json do
        MultiJson.encode(@record.values)
      end

      # edit
      get '/:id/edit', provides: :html do
        slim :"#{resource_name}/edit", locals: { :"#{record_name}" => @record }
      end

      # update
      put '/:id' do
        @record.update(params[:"#{record_name}"])
        pass
      end

      put '/:id', provides: :html do
        redirect to "/#{@record.id}"
      end

      put '/:id', provides: :json do
        204
      end

      # destroy
      delete '/:id' do
        halt 403 unless @record.destroy
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
      
      protected
      
        def resource_name
          @resource.name.split(':').last.downcase + 's' if @resource
        end
        
        def record_name
          @resource.name.split(':').last.downcase if @resource
        end
    end
  end
end
