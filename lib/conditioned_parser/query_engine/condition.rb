module ConditionedParser
  module QueryEngine
    # Represents a generic condition for parsing
    class Condition
      ALLOWED_TYPES = %i[must must_not].freeze
      attr_accessor :item, :pattern
      attr_accessor :selector

      def initialize(pattern, selector, type)
        @pattern = pattern
        @selector = selector
        @item = selector.select_content
        @type = type
      end

      def matches?
        !matches.nil?
      end

      def matches
        # implemented by subclasses
      end

      ## Condition refactoring here:
      def evaluate?
        case @type
        when :must
          matches?
        when :must_not
          !matches?
        end
      end
    end
  end
end
