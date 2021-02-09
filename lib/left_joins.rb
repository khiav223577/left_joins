require "left_joins/version"
require 'active_record'
require 'active_record/relation'

module LeftJoins
  IS_RAILS3_FLAG = Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.0')
  HAS_BUILT_IN_LEFT_JOINS_METHOD = ActiveRecord::QueryMethods.method_defined?(:left_outer_joins)
  require 'left_joins_for_rails_3' if IS_RAILS3_FLAG

  class << self
    def patch(target, method, as:)
      return yield if target.singleton_methods.include?(method)

      target.define_singleton_method(method, &as)
      result = yield
      target.singleton_class.send(:remove_method, method)

      return result
    end
  end
end

module ActiveRecord::QueryMethods
  if not LeftJoins::HAS_BUILT_IN_LEFT_JOINS_METHOD
    # ----------------------------------------------------------------
    # ● Storing left joins values into @left_outer_joins_values
    # ----------------------------------------------------------------
    attr_writer :left_outer_joins_values
    def left_outer_joins_values
      @left_outer_joins_values ||= []
    end

    def left_outer_joins(*args)
      check_if_method_has_arguments!(:left_outer_joins, args)

      args.compact!
      args.flatten!
      self.distinct_value = false if self.distinct_value == nil

      return (LeftJoins::IS_RAILS3_FLAG ? clone : spawn).left_outer_joins!(*args)
    end

    def left_outer_joins!(*args)
      left_outer_joins_values.concat(args)
      self
    end

    # ----------------------------------------------------------------
    # ● Implement left joins when building arel
    # ----------------------------------------------------------------
    alias_method :left_joins, :left_outer_joins
    alias_method :build_arel_without_outer_joins, :build_arel
    def build_arel(*args)
      arel = build_arel_without_outer_joins(*args)
      build_left_outer_joins(arel, @left_outer_joins_values) if @left_outer_joins_values
      return arel
    end

    alias_method :build_joins_without_join_type, :build_joins
    def build_joins(manager, joins, join_type = nil)
      Thread.current.thread_variable_set(:left_joins_join_type, join_type)
      result = build_joins_without_join_type(manager, joins)
      Thread.current.thread_variable_set(:left_joins_join_type, nil)
      return result
    end

    def build_left_outer_joins(manager, joins)
      result = build_joins(manager, joins, Arel::Nodes::OuterJoin)
      return result
    end

    class << ::ActiveRecord::Base
      def left_joins(*args)
        self.where('').left_joins(*args)
      end
      alias_method :left_outer_joins, :left_joins
    end

    class ::ActiveRecord::Associations::JoinDependency
      if private_method_defined?(:make_constraints)
        alias_method :make_constraints_without_hooking_join_type, :make_constraints
        def make_constraints(*args, join_type)
          join_type = Thread.current.thread_variable_get(:left_joins_join_type) || join_type
          return make_constraints_without_hooking_join_type(*args, join_type)
        end
      else
        alias_method :build_without_hooking_join_type, :build
        def build(associations, parent = nil, join_type = Arel::Nodes::InnerJoin)
          join_type = Thread.current.thread_variable_get(:left_joins_join_type) || join_type
          return build_without_hooking_join_type(associations, parent, join_type)
        end
      end
    end

    module ActiveRecord::Calculations
      # This method is copied from activerecord-4.2.10/lib/active_record/relation/calculations.rb
      # and modified this line `distinct = true` to `distinct = true if distinct == nil`
      def perform_calculation(operation, column_name, options = {})
        # TODO: Remove options argument as soon we remove support to
        # activerecord-deprecated_finders.
        operation = operation.to_s.downcase

        # If #count is used with #distinct / #uniq it is considered distinct. (eg. relation.distinct.count)
        distinct = options[:distinct] || self.distinct_value

        if operation == "count"
          column_name ||= (select_for_count || :all)

          unless arel.ast.grep(Arel::Nodes::OuterJoin).empty?
            distinct = true if distinct == nil
          end

          column_name = primary_key if column_name == :all && distinct
          distinct = nil if column_name =~ /\s*DISTINCT[\s(]+/i
        end

        if group_values.any?
          execute_grouped_calculation(operation, column_name, distinct)
        else
          execute_simple_calculation(operation, column_name, distinct)
        end
      end
    end
  end
end

# ----------------------------------------------------------------
# ● Implement left joins when merging relations
# ----------------------------------------------------------------
if not LeftJoins::IS_RAILS3_FLAG
  require 'active_record/relation/merger'
  class ActiveRecord::Relation
    class Merger
      alias_method :merge_without_left_joins, :merge
      def merge
        merge_without_left_joins
        merge_outer_joins
        relation
      end

      # code fusion of :
      # * method merge_outer_joins in activerecord-5.2.0/lib/active_record/relation/merger.rb
      # * method merge_joins in activerecord-4.2.10/lib/active_record/relation/merger.rb
      def merge_outer_joins
        return if other.left_outer_joins_values.blank?

        if other.klass == relation.klass
          relation.left_outer_joins!(*other.left_outer_joins_values)
        else
          joins_dependency, rest = other.left_outer_joins_values.partition do |join|
            case join
            when Hash, Symbol, Array
              true
            else
              false
            end
          end

          join_dependency = ActiveRecord::Associations::JoinDependency.new(other.klass,
                                                                           joins_dependency,
                                                                           [])
          relation.left_outer_joins!(rest)
          @relation = relation.left_outer_joins join_dependency
        end
      end

    end
  end

  module ActiveRecord
    module SpawnMethods

      private

      alias_method :relation_with_without_left_joins, :relation_with
      def relation_with(values) # :nodoc:
        result = relation_with_without_left_joins(values)
        result.left_outer_joins_values = self.left_outer_joins_values
        return result
      end
    end
  end
end

# ----------------------------------------------------------------
# ● Implement left joins in update statement
# ----------------------------------------------------------------
module ActiveRecord
  class Relation
    if not LeftJoins::HAS_BUILT_IN_LEFT_JOINS_METHOD
      alias_method :update_all_without_left_joins_values, :update_all

      def update_all(*args)
        local_joins_values = joins_values.clone
        has_left_outer_joins = left_outer_joins_values.any?

        LeftJoins.patch(self, :joins_values, as: ->{ local_joins_values }) do
          LeftJoins.patch(local_joins_values, :any?, as: ->{ super() || has_left_outer_joins }) do
            update_all_without_left_joins_values(*args)
          end
        end
      end
    end
  end
end
