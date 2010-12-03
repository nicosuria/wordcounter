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
      instance_words = []
      wordcounted_fields.each do |field|
        next if self.send(field).nil?
        self.send(field).split.each do |w|
          instance_words << clean(w) unless clean(w).blank?
        end
      end    
      instance_words 
    end
    
    def countable_association_words
      association_words = []
      wordcounted_associations.each_pair do |association, fields|
        self.send(association).each do |obj|
          fields.each  do |field|
             next if obj.send(field).nil?
             obj.send(field).split.each do |w|
               association_words << clean(w) unless clean(w).blank?
             end
           end
        end
      end
      association_words
    end
    
    def load_words_to_cache(options={})
      raise "Please define a method or column called :cached_words to handle wordset storage" unless self.respond_to?("cached_words=")
      self.cached_words = countable_words
      save(false) unless options[:save_record].eql?(false)
    end
    
    def countable_words      
      ((countable_instance_words + countable_association_words) - ignored_words).each(&:downcase!)
    end
    
    def ignored_words
      YAML::load_file(File.dirname(__FILE__) + '/ignored_words.yml').split
    end
    
    def top_words(options={})
      count_hash = word_count(options)
      count_hash.sort{|a,b| b[1]<=>a[1]}[0...(options[:limit] || count_hash.size)].collect{|h| h.first}
    end    
  
    def word_count(options={})
      count_hash = {}
      count_hash.default = 0
      
      words = self.respond_to?(:cached_words) ? cached_words : countable_words
      
      if options[:for].nil?      
        words.collect{|word| count_hash[clean(word)] += 1 unless clean(word).blank?}
      else     
        if options[:for].is_a?(Array)
          
          options[:for].collect do |word| 
            count = words.join(' ').scan(word.downcase).size            
            count_hash[word.downcase] = count unless count.zero?
          end
        else
          count_hash[options[:for]] = words.join(' ').scan(options[:for]).size
        end
      end
      count_hash
    end
      
    private
    def clean(string)
      string.gsub(/[^[:alnum:]]/, '').downcase 
    end
  end
end

ActiveRecord::Base.class_eval do
  include Wordcounter
end