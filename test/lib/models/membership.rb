class Membership < ActiveRecord::Base
  belongs_to :organization, counter_cache: :memberships_count
end
