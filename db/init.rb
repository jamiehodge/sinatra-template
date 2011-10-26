require 'logger'

DB = Sequel.sqlite(File.join(File.dirname(__FILE__), "#{ENV['RACK_ENV']}.db"))

DB.loggers << Logger.new($stdout)