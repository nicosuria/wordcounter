class CachedWordCount < ActiveRecord::Base
  belongs_to :object, :polymorphic => true
  
  serialize :words
end