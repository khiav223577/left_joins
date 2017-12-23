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

module ActiveRecord
  module Associations
    class JoinDependency
      if not method_defined?(:make_outer_joins)
        def join_constraints(outer_joins, join_type = nil)
          @_left_joins_join_type = join_type if join_type
          result = join_constraints_without_join_type(outer_joins)
          @_left_joins_join_type = nil
          return result
        end

        private

        def make_inner_joins(parent, child)
          tables    = table_aliases_for(parent, child)
          join_type = @_left_joins_join_type || Arel::Nodes::InnerJoin
          info      = make_constraints parent, child, tables, join_type

          [info] + child.children.flat_map { |c| make_inner_joins(child, c) }
        end
      end
    end
  end
end

class ActiveRecord::Base
  def self.left_joins(*args, &block)
    self.where('').left_joins(*args, &block)
  end

  def self.left_outer_joins(*args, &block)
    self.where('').left_outer_joins(*args, &block)
  end
end
