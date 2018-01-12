require 'pluck_all'

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

  create_table :post_comments, :force => true do |t|
    t.integer :post_id
    t.string :comment
  end
end

class User < ActiveRecord::Base
  serialize :serialized_attribute, Hash
  has_many :posts
  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.0')
    has_many :posts_with_comments2, class_name: 'Post'
    has_many :posts_and_comments2 , class_name: 'Post'
    def posts_with_comments
      posts_with_comments2.joins(:post_comments)
    end

    def posts_and_comments
      posts_and_comments2.left_joins(:post_comments)
    end
  else
    has_many :posts_with_comments, ->{ joins(:post_comments) }, class_name: 'Post'
    has_many :posts_and_comments , ->{ left_joins(:post_comments) }, class_name: 'Post'
  end
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_comments
end

class PostComment < ActiveRecord::Base
  belongs_to :post
end

users = User.create([
  {:name => 'John1', :email => 'john1@example.com'},
  {:name => 'John2', :email => 'john2@example.com', :serialized_attribute => {:testing => true, :deep => {:deep => :deep}}},
  {:name => 'John3', :email => 'john3@example.com'},
  {:name => 'John4', :email => 'john4@example.com'},
])

posts = Post.create([
  {:title => "John1's post1", :user_id => users[0].id},
  {:title => "John1's post2", :user_id => users[0].id},
  {:title => "John1's post3", :user_id => users[0].id},
  {:title => "John2's post1", :user_id => users[1].id},
  {:title => "John2's post2", :user_id => users[1].id},
  {:title => "John3's post1", :user_id => users[2].id},
])

PostComment.create([
  {:post_id => posts[2].id, :comment => "WTF?"},
  {:post_id => posts[2].id, :comment => "..."},
  {:post_id => posts[3].id, :comment => "cool!"},
  {:post_id => posts[5].id, :comment => "hahahahahahha"},
])
