require_relative 'spec_helper'

class MyAppSpec < SequelSpec
    
  describe 'The MyApp App' do
    
    it 'must welcome you' do
      get '/'
      last_response.status.must_equal 200
    end
    
  end
end