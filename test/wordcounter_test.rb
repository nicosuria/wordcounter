require File.join(File.dirname(__FILE__), 'test_helper')

class WordcounterTest < Test::Unit::TestCase
  
  def test_article_should_be_creatable
    @article = Article.new(:title => "Lorem Ipsum")
    assert_equal @article.title, "Lorem Ipsum"
  end
  
  def test_article_should_return_correct_word_count
    @article = Article.new(:title => "Lorem Ipsum", :body => "lorem ipsum ipsum")
    assert_equal @article.word_count['lorem'], 2
    assert_equal @article.word_count['ipsum'], 3
  end
end
