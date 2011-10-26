require_relative 'spec_helper'

class MyAppSpec < SequelSpec
  def app
    Rack::Builder.new do
      use Warden::Manager do |manager|
        manager.default_strategies :password
        manager.failure_app = MyApp
      end
      run MyApp
    end
  end
  
  describe 'The MyApp App' do
    
    it 'must welcome you' do
      get '/'
      last_response.status.must_equal 200
    end
    
  end
end