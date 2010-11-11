class Article < ActiveRecord::Base
  has_many :comments
  wordcounter :fields => [:title, :body],
    :associations => {
      :comments => [:title, :body]
    }
end