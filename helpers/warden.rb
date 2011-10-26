# encoding: utf-8

module Sinatra
  module WardenHelpers
    def warden
      env['warden']
    end

    def protected!(scope=:default)
      throw(:warden) unless warden.authenticated?(scope)
    end
  end
  helpers WardenHelpers
end