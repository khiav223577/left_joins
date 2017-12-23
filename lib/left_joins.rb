require "left_joins/version"
require 'active_record'

class ActiveRecord::Relation
  IS_RAILS3_FLAG = Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.0')
  IS_RAILS5_FLAG = Gem::Version.new(ActiveRecord::VERSION::STRING) >= Gem::Version.new('5.0.0')
  if not method_defined?(:left_joins)
    def left_joins(args)
      6
    end
  end

  alias_method :left_outer_joins, :left_joins if not method_defined?(:left_outer_joins)
end

class ActiveRecord::Base
  def self.left_joins(*args, &block)
    self.where('').left_joins(*args, &block)
  end

  def self.left_outer_joins(*args, &block)
    self.where('').left_outer_joins(*args, &block)
  end
end
