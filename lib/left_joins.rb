require "left_joins/version"
require 'active_record'
require 'active_record/relation'

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

    alias_method :build_joins_without_join_type, :build_joins
    def build_joins(manager, joins, join_type = Arel::Nodes::InnerJoin)
      Thread.current.thread_variable_set :left_joins_join_type, join_type
      result = build_joins_without_join_type(manager, joins)
      Thread.current.thread_variable_set :left_joins_join_type, nil
      return result
    end

    def build_left_outer_joins(manager, joins)
      result = build_joins(manager, joins, Arel::Nodes::OuterJoin)
      return result
    end

    module ActiveRecord::Querying
      delegate :left_joins, :left_outer_joins, to: :all 
    end

    class ::ActiveRecord::Associations::JoinDependency
      alias_method :make_constraints_without_hooking_join_type, :make_constraints
      def make_constraints(*args, join_type)
        join_type = Thread.current.thread_variable_get :left_joins_join_type || join_type
        return make_constraints_without_hooking_join_type(*args, join_type)
      end
    end
  end
end


