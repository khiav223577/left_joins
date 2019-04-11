require 'test_helper'

class LeftOuterJoinsValuesTest < Minitest::Test
  def setup
  end

  def test_empty_relation
    assert_equal [], User.where('').left_outer_joins_values
    assert_equal [], User.where('').joins_values
  end

  def test_joins
    assert_equal [], User.joins(:posts).left_outer_joins_values
    assert_equal [:posts], User.joins(:posts).joins_values
  end

  def test_left_joins
    assert_equal [:posts], User.left_joins(:posts).left_outer_joins_values
    assert_equal [], User.left_joins(:posts).joins_values
  end
end
