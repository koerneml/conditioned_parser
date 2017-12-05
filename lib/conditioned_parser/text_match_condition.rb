module ConditionedParser
  # Represents a textual matching condition
  class TextMatchCondition < Condition
    def matches
      @item.contained_text.match(@pattern)
    end
  end
end
