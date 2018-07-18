# ----------------------------------------------------------------
# ● Implement check_if_method_has_arguments! method for Rails 3
# ----------------------------------------------------------------
module ActiveRecord::QueryMethods
  def check_if_method_has_arguments!(method_name, args)
    if args.blank?
      raise ArgumentError, "The method .#{method_name}() must contain arguments."
    end
  end
end

module ActiveRecord::Calculations
  def distinct_value
    uniq_value
  end

  def distinct_value=(v)
    self.uniq_value = v
  end
end
