class PostComment < ActiveRecord::Base
  belongs_to :post
  has_many :post_comment_ratings

  scope :has_rating_of, ->(rated) { left_joins(:post_comment_ratings).where(post_comment_ratings: { rated: rated }) }
end
