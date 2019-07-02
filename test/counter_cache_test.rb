require 'test_helper'

class CounterCacheTest < Minitest::Test
  def test_left_joins
    organization = Organization.create name: 'Organization 01'
    membership   = Membership.create name: 'A Memberships', organization: organization

    assert_equal organization.memberships.first, membership
  end
end
