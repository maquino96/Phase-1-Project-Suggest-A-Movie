require 'bundler'
require 'net/http'

Bundler.require
require 'net/http'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'app'
