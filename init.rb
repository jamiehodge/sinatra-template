ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

%w{db models app}.each do |f| 
  require_relative File.join(f, 'init')
end

require_relative 'strategies'