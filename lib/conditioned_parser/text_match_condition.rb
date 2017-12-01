module ConditionedParser
  # Represents a textual matching condition
  class TextMatchCondition < Condition
    def matches
      @item.match(@pattern)
    end
  end
end
