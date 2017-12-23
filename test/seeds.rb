ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string :name
    t.string :email
    t.text :serialized_attribute
  end
  create_table :posts, :force => true do |t|
    t.integer :user_id
    t.string :title
  end
end
class User < ActiveRecord::Base
  serialize :serialized_attribute, Hash
  has_many :posts
end
class Post < ActiveRecord::Base
  belongs_to :user
end
users = User.create([
  {:name => 'John1', :email => 'john1@example.com'},
  {:name => 'John2', :email => 'john2@example.com', :serialized_attribute => {:testing => true, :deep => {:deep => :deep}}},
  {:name => 'John3', :email => 'john3@example.com'},
])
Post.create([
  {:title => "John1's post1", :user_id => users[0].id},
  {:title => "John1's post2", :user_id => users[0].id},
  {:title => "John1's post3", :user_id => users[0].id},
  {:title => "John2's post1", :user_id => users[1].id},
  {:title => "John2's post2", :user_id => users[1].id},
  {:title => "John3's post1", :user_id => users[2].id},
])
