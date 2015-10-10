require 'data_mapper'
require 'dm-validations'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/chitter_#{env}")

require './app/models/users'
require './app/models/peeps'

DataMapper.finalize

DataMapper.auto_upgrade!
