class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_comments

  scope :has_comment_with_rating_of, ->(rated) { joins(:post_comments).merge(PostComment.has_rating_of(rated)) }
end
