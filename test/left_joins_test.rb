require 'test_helper'

class LeftJoinsTest < Minitest::Test
  def setup
    
  end

  def test_left_joins
    assert_equal 6, User.joins(:posts).count
    assert_equal 7, User.left_joins(:posts).count
  end

  def test_left_outer_joins_alias
    assert_equal User.left_outer_joins(:posts).count, User.left_joins(:posts).count
  end

  def test_left_joins_on_has_many_association
    assert_equal 1, User.find_by(name: 'John1').posts.joins(:post_comments).distinct.size
    assert_equal 3, User.find_by(name: 'John1').posts.left_joins(:post_comments).distinct.size
  end
end
