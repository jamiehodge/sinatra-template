ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

Dir.glob('./config/*.rb').each do |file|
  require file
end

Dir.glob('./app/{models,helpers,controllers}/*.rb').each do |file|
  require file
end