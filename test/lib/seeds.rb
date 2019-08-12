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

  create_table :organizations, force: true do |t|
    t.string  :name
    t.integer :memberships_count, default: 0
    t.timestamps null: false
  end

  create_table :memberships, force: true do |t|
    t.string  :name
    t.references :organization
    t.timestamps null: false
  end
end

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../models/', __FILE__)

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
