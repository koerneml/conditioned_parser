module ConditionedParser
  # Represents a generic condition for parsing
  class Condition
    attr_accessor :item, :pattern

    def initialize(content_element, pattern)
      @item = content_element
      @pattern = pattern
    end

    def and(other_condition)
      matches? && other_condition.matches?
    end

    def or(other_condition)
      matches? || other_condition.matches?
    end

    def not
      !matches?
    end

    def matches?
      !matches.nil?
    end

    def matches
      # implemented by subclasses
    end
  end
end
