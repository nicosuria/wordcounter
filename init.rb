require 'wordcounter'
ActiveRecord::Base.send(:include, Wordcounter)

Dir['lib/models/*.rb'].each { |f| require f }