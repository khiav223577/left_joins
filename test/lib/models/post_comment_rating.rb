class PostCommentRating < ActiveRecord::Base
  belongs_to :post_comment
  belongs_to :evaluator, class_name: 'User'
end
