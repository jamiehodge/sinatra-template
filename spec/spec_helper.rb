ENV['RACK_ENV'] = 'test'

require_relative '../init'

class SequelSpec < MiniTest::Spec
  include Rack::Test::Methods
  include Warden::Test::Helpers

  def after
    Warden.test_reset!
  end
  
  def run(*args, &block)
    Sequel::Model.db.transaction do
      super
      raise Sequel::Rollback
    end
  end
end
