require 'test_helper'

class LeftJoinsMergerTest < Minitest::Test
  def setup
  end

  def test_left_joins_on_merge
    user = User.find_by(email: 'john1@example.com')

    # before patch an exception was raised : ActiveRecord::ConfigurationError: Association named 'post_comment_ratings' was not found on Post;
    # Note : assert_nothing_raised could be considered as an anti-pattern
    assert_equal Post.where(title: "John1's post3"), user.posts.has_comment_with_rating_of(10)
  end
end
