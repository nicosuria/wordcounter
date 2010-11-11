require 'test/unit'
require 'rubygems'
gem 'activerecord'
require 'active_record'
require File.join(File.dirname(__FILE__), '../lib/wordcounter')

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
  # no ruby debugger
end

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

Dir['test/models/**/*.rb'].each { |f| require f }

load 'test/db/schema.rb'