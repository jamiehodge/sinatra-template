require 'sinatra/resource'

module App
  module Controller
    class Users < Base
      register Sinatra::Resource
      
      set :resource, App::Model::User
    end
  end
end