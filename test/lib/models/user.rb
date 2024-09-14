class User < ActiveRecord::Base
  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('7.1.0')
    serialize :serialized_attribute, Hash
  else
    serialize :serialized_attribute, type: Hash
  end

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
