ActiveRecord::Schema.define do
  create_table "articles", :force => true do |t|
    t.column  :title, :text
    t.column  :body, :text
  end
  
  create_table "comments", :force => true do |t|
    t.references  :article
    t.column  :title, :text
    t.column  :body, :text
  end
end