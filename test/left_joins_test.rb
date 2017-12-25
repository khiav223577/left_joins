require 'test_helper'

class LeftJoinsTest < Minitest::Test
  def setup
    
  end

  def test_left_joins
    assert_equal 6, User.joins(:posts).count
    assert_equal 7, User.left_joins(:posts).to_a.size # FIXME
  end

  def test_left_outer_joins_alias
    assert_equal User.left_outer_joins(:posts).count, User.left_joins(:posts).count
  end
end
