module App
  module Controller
    class Users < Resource
      
      def initialize(app = nil)
        @resource = App::Model::User
        super
      end
    end
  end
end