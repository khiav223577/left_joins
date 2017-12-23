require "left_joins/version"
require 'active_record'

module ActiveRecord::QueryMethods
  if not method_defined?(:left_outer_joins!)

    def left_outer_joins(*args)
      check_if_method_has_arguments!(:left_outer_joins, args)

      args.compact!
      args.flatten!

      spawn.left_outer_joins!(*args)
    end

    def left_outer_joins!(*args) # :nodoc:
      (@left_outer_joins_values ||= []) << args
      self
    end

    alias_method :left_joins, :left_outer_joins
    alias_method :build_arel_without_outer_joins, :build_arel
    def build_arel(*args)
      arel = build_arel_without_outer_joins(*args)
      build_left_outer_joins(arel, @left_outer_joins_values.flatten) if @left_outer_joins_values
      return arel
    end

    def build_left_outer_joins(manager, joins)
      @_left_joins_join_type = Arel::Nodes::OuterJoin
      result = build_joins(manager, joins)
      @_left_joins_join_type = nil
      return result
    end

    class ::ActiveRecord::Associations::JoinDependency
      def make_inner_joins(parent, child)
        tables    = table_aliases_for(parent, child)
        join_type = @_left_joins_join_type || Arel::Nodes::InnerJoin
        info      = make_constraints parent, child, tables, join_type

        [info] + child.children.flat_map { |c| make_inner_joins(child, c) }
      end
    end
  end
end


module ActiveRecord
  module Querying
    delegate :left_joins, :left_outer_joins, to: :all 
  end
end
