require 'logger'

DB = Sequel.sqlite("db/#{ENV['RACK_ENV']}.db")
DB.loggers << Logger.new($stdout)