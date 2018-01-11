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
    assert_equal 1, User.where(name: 'John1').first.posts.joins(:post_comments).distinct.size
    assert_equal 3, User.where(name: 'John1').first.posts.left_joins(:post_comments).distinct.size
  end

  def test_left_joins_on_association_condition
    assert_equal [
      ["John1's post3", 'WTF?'],
      ["John1's post3", '...'],
    ], User.where(name: 'John1').first.posts_with_comments.order('post_comments.id').pluck(:title, :comment)

    assert_equal [
      ["John1's post1", nil],
      ["John1's post2", nil],
      ["John1's post3", 'WTF?'],
      ["John1's post3", '...'],
    ], User.where(name: 'John1').first.posts_and_comments.order('post_comments.id').pluck(:title, :comment)
  end
end
