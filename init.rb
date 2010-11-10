require 'wordcounter'
ActiveRecord::Base.send(:include, Wordcounter)