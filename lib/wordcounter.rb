require 'active_record'
require 'yaml'

module Wordcounter
  def self.included(mod)
    mod.extend(ClassMethods)
  end
  
  module ClassMethods
    def wordcounter(options={})    
      class_eval do
        extend Wordcounter::SingletonMethods
      end
      include Wordcounter::InstanceMethods
      
      cattr_accessor :wordcounted_fields, :wordcounted_associations
      
      self.wordcounted_associations = options[:associations]
      self.wordcounted_fields = options[:fields]
    end
  end
  
  module SingletonMethods
    
  end
  
  module InstanceMethods
    def countable_instance_words
      wordcounted_fields.inject([]) do |words, field|
        words += (self.send(field).nil? ? [] : self.send(field).split)
      end     
    end
    
    def countable_association_words
      words = []
      wordcounted_associations.each_pair do |association, fields|
        self.send(association).each do |obj|
          fields.collect{|field| words += (obj.send(field).nil? ? [] : obj.send(field).split)}          
        end
      end
      words
    end
    
    def countable_words
      (countable_instance_words + countable_association_words) - ignored_words
    end
    
    def ignored_words
      YAML::load_file(File.dirname(__FILE__) + '/ignored_words.yml').split
    end
    
    def word_count
      count_hash = {}
      count_hash.default = 0
      countable_words.each do |word|
        count_hash[word.downcase] += 1          
      end
      count_hash
    end
  end
end


ActiveRecord::Base.class_eval do
  include Wordcounter
end