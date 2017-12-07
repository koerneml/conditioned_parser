module ConditionedParser
  module QueryEngine
    # Represents a textual matching condition
    class TextMatchCondition < Condition
      def matches
        @item.match(@pattern)
      end
    end
  end
end
