require File.join(File.dirname(__FILE__), 'test_helper')

class WordcounterTest < Test::Unit::TestCase
  
  def test_article_should_be_creatable
    @article = Article.new(:title => "Lorem Ipsum")
    assert_equal @article.title, "Lorem Ipsum"
  end
  
  def test_article_should_return_correct_word_count
    @article = Article.create(:title => "Lorem Ipsum", :body => "lorem ipsum ipsum")
    assert_equal @article.word_count['lorem'], 2
    assert_equal @article.word_count['ipsum'], 3
  end
  
  def test_article_and_comment_should_return_correct_word_count
    @article = Article.create(:title => "Lorem Ipsum", :body => "lorem ipsum ipsum")
    @article.comments.create(:title => "Lorem Ipsum", :body=> "lorem ipsum ipsum")
    assert_equal @article.word_count['lorem'], 4
    assert_equal @article.word_count['ipsum'], 6
  end
  
  def test_article_should_be_able_to_count_the_occurrence_of_a_phrase
    @article = Article.create(:title => "Lorem Ipsum", :body => "lorem ipsum ipsum")
    assert_equal @article.word_count(:for => "lorem ipsum")["lorem ipsum"], 2
  end
  
  def test_article_should_be_able_to_count_the_occurence_of_multiple_phrases
    @article = Article.create(:title => "Lorem Ipsum", :body => "lorem ipsum ipsum")
    word_count = @article.word_count(:for => ["lorem ipsum", 'ipsum ipsum'])
    assert_equal word_count["lorem ipsum"], 2
    assert_equal word_count["ipsum ipsum"], 1
  end
  
  def test_article_and_comments_should_be_able_to_count_the_occurence_of_multiple_phrases
     @article = Article.create(:title => "Lorem Ipsum", :body => "lorem ipsum ipsum")
     @article.comments.create(:title => "Lorem Ipsum", :body=> "lorem ipsum ipsum")
     word_count = @article.word_count(:for => ["lorem ipsum", 'ipsum ipsum'])
     assert_equal word_count["lorem ipsum"], 4
     assert_equal word_count["ipsum ipsum"], 2
   end
end
